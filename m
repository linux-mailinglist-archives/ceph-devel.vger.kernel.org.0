Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA2E45A59E
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 15:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhKWOaS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Nov 2021 09:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhKWOaR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 480AD60E54;
        Tue, 23 Nov 2021 14:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637677629;
        bh=sgbBe7gPJ9CRbmDszC4j/0N+eoyRw1dvuamFMpmpk0U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YprJq/tg9p1ghoegv8SPz9YssB8XLQU0Ezx/afsIsvWWGmaFfBpRFuRDSXYz8mrM3
         M7pfMwLORMYHKhlwE1TWFqT49mMpvacPvFQo0BaAZme72Xeu/FH+HvepIxXWJukChw
         iwJLfEw1DY+X8YQsEQ7QnW2+1TnR7YmPLn7pSxAQVsr2juocpO00wQrkJRUYieW2Na
         aWF8Xol/5NpZgqJN3NrU8EOsmHf49jBO3f+5Vw5a03AgW7Tui6kMXe8RDx31Urrmqw
         LHOq+uUZ9F3Y/i9sGGGotWbQCHxIqgysPQnjuoOb2vjhgfcmzDznQz8lCdmCGqmNS3
         6tWbIPW/AXGzA==
Message-ID: <f3185ff85d5ffbb28d82b8b04727879a04c92436.camel@kernel.org>
Subject: Re: [PATCH] ceph: fscrypt always set the header.block_size to
 CEPH_FSCRYPT_BLOCK_SIZE
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 23 Nov 2021 09:27:08 -0500
In-Reply-To: <20211123102004.40149-1-xiubli@redhat.com>
References: <20211123102004.40149-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-23 at 18:20 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When hit a file hole, will keep the header.assert_ver as 0, and
> in MDS side it will check it to decide whether should it do a
> RMW.
> 
> And always set the header.block_size to CEPH_FSCRYPT_BLOCK_SIZE,
> because even in the hole case, the MDS will need to use this to
> do the filer.truncate().
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> 
> Hi Jeff, 
> 
> Please squash this patch to the previous "ceph: add truncate size handling support for fscrypt" commit in ceph-client/wip-fscrypt-size branch.
> 
> And also please sync the ceph PR, I have updated it too.
> 
> 
> 

Thanks Xiubo. The branches should be updated now. Note that I dropped
this patch since it was causing regressions for me:

    [PATCH] ceph: do not truncate pagecache if truncate size doesn't change

With a kernel from the current wip-fscrypt-size branch, and a ceph
cluster based on your fsize_support branch, I still got a failure on
generic/029:

generic/029 8s ... - output mismatch (see /home/jlayton/git/xfstests-dev/results//generic/029.out.bad)
    --- tests/generic/029.out	2020-11-09 14:47:52.488429897 -0500
    +++ /home/jlayton/git/xfstests-dev/results//generic/029.out.bad	2021-11-23 09:07:18.121501769 -0500
    @@ -24,13 +24,6 @@
     *
     00001400
     ==== Post-Remount ==
    -00000000  58 58 58 58 58 58 58 58  58 58 58 58 58 58 58 58  |XXXXXXXXXXXXXXXX|
    -*
    -00000400  57 57 57 57 57 57 57 57  57 57 57 57 57 57 57 57  |WWWWWWWWWWWWWWWW|
    -*
    ...
    (Run 'diff -u /home/jlayton/git/xfstests-dev/tests/generic/029.out /home/jlayton/git/xfstests-dev/results//generic/029.out.bad'  to see the entire diff)


Basically, after the second xfs_io test in generic/029, the entire file
was zeroed out. I still am unable to reproduce this every time however.
It mostly seems to occur when I do a full -g quick run. If I run
generic/029 in a loop, it rarely fails.

Here's the test, basically:

# second case is to do a mwrite between the truncate to a block on the
# same page we are truncating within the EOF. This checks that a mapped
# write between truncate down and truncate up a further mapped
# write to the same page into the new space doesn't result in data being lost.
$XFS_IO_PROG -t -f \
-c "truncate 5120"              `# truncate     |                        |` \
-c "pwrite -S 0x58 0 5120"      `# write        |XXXXXXXXXXXXXXXXXXXXXXXX|` \
-c "mmap -rw 0 5120"            `# mmap         |                        |` \
-c "mwrite -S 0x5a 2048 3072"   `# mwrite       |          ZZZZZZZZZZZZZZ|` \
-c "truncate 2048"              `# truncate dn  |         |` \
-c "mwrite -S 0x57 1024 1024"   `# mwrite       |     WWWWW              |` \
-c "truncate 5120"              `# truncate up  |                        |` \
-c "mwrite -S 0x59 2048 3072"   `# mwrite       |          YYYYYYYYYYYYYY|` \
-c "close"      \
$testfile | _filter_xfs_io
 
echo "==== Pre-Remount ==="
hexdump -C $testfile
_scratch_cycle_mount
echo "==== Post-Remount =="
hexdump -C $testfile


I'll keep playing with this today, and see if I can get closer to a
reliable reproducer. 

> 
> 
>  fs/ceph/inode.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 53b8e2ff3678..b4f7a4b4f15c 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2312,6 +2312,12 @@ static int fill_fscrypt_truncate(struct inode *inode,
>  	header.ver = 1;
>  	header.compat = 1;
>  
> +	/*
> +	 * Always set the block_size to CEPH_FSCRYPT_BLOCK_SIZE,
> +	 * because in MDS it may need this to do the truncate.
> +	 */
> +	header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
> +
>  	/*
>  	 * If we hit a hole here, we should just skip filling
>  	 * the fscrypt for the request, because once the fscrypt
> @@ -2327,15 +2333,19 @@ static int fill_fscrypt_truncate(struct inode *inode,
>  		     pos, i_size);
>  
>  		header.data_len = cpu_to_le32(8 + 8 + 4);
> +
> +		/*
> +		 * If the "assert_ver" is 0 means hitting a hole, and
> +		 * the MDS will use the it to check whether hitting a
> +		 * hole or not.
> +		 */
>  		header.assert_ver = 0;
>  		header.file_offset = 0;
> -		header.block_size = 0;
>  		ret = 0;
>  	} else {
>  		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
>  		header.assert_ver = cpu_to_le64(objvers.objvers[0].objver);
>  		header.file_offset = cpu_to_le64(orig_pos);
> -		header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
>  
>  		/* truncate and zero out the extra contents for the last block */
>  		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);

-- 
Jeff Layton <jlayton@kernel.org>
