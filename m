Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD27CABDAE
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 18:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbfIFQ0y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Sep 2019 12:26:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:47034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfIFQ0y (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 6 Sep 2019 12:26:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D6516AE62;
        Fri,  6 Sep 2019 16:26:51 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ceph: allow object copies across different filesystems in the same cluster
References: <20190906135750.29543-1-lhenriques@suse.com>
        <30b09cb015563913d073c488c8de8ba0cceedd7b.camel@kernel.org>
Date:   Fri, 06 Sep 2019 17:26:51 +0100
In-Reply-To: <30b09cb015563913d073c488c8de8ba0cceedd7b.camel@kernel.org> (Jeff
        Layton's message of "Fri, 06 Sep 2019 12:18:10 -0400")
Message-ID: <87sgp9o0fo.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

"Jeff Layton" <jlayton@kernel.org> writes:

> On Fri, 2019-09-06 at 14:57 +0100, Luis Henriques wrote:
>> OSDs are able to perform object copies across different pools.  Thus,
>> there's no need to prevent copy_file_range from doing remote copies if the
>> source and destination superblocks are different.  Only return -EXDEV if
>> they have different fsid (the cluster ID).
>> 
>> Signed-off-by: Luis Henriques <lhenriques@suse.com>
>> ---
>>  fs/ceph/file.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>> 
>> Hi!
>> 
>> I've finally managed to run some tests using multiple filesystems, both
>> within a single cluster and also using two different clusters.  The
>> behaviour of copy_file_range (with this patch, of course) was what I
>> expected:
>> 
>>   - Object copies work fine across different filesystems within the same
>>     cluster (even with pools in different PGs);
>>   - -EXDEV is returned if the fsid is different
>> 
>> (OT: I wonder why the cluster ID is named 'fsid'; historical reasons?
>>  Because this is actually what's in ceph.conf fsid in "[global]"
>>  section.  Anyway...)
>> 
>> So, what's missing right now is (I always mention this when I have the
>> opportunity!) to merge https://github.com/ceph/ceph/pull/25374 :-)
>> And add the corresponding support for the new flag to the kernel
>> client, of course.
>> 
>> Cheers,
>> --
>> Luis
>> 
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 685a03cc4b77..88d116893c2b 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>>  	struct ceph_inode_info *src_ci = ceph_inode(src_inode);
>>  	struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
>>  	struct ceph_cap_flush *prealloc_cf;
>> +	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
>>  	struct ceph_object_locator src_oloc, dst_oloc;
>>  	struct ceph_object_id src_oid, dst_oid;
>>  	loff_t endoff = 0, size;
>> @@ -1915,8 +1916,22 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>>  
>>  	if (src_inode == dst_inode)
>>  		return -EINVAL;
>> -	if (src_inode->i_sb != dst_inode->i_sb)
>> -		return -EXDEV;
>> +	if (src_inode->i_sb != dst_inode->i_sb) {
>> +		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
>> +
>> +		if (!src_fsc->client->have_fsid || !dst_fsc->client->have_fsid) {
>> +			dout("No fsid in a fs client\n");
>> +			return -EXDEV;
>> +		}
>
> In what situation is there no fsid? Old cluster version?
>
> If there is no fsid, can we take that to indicate that there is only a
> single filesystem possible in the cluster and that we should attempt the
> copy anyway?

TBH I'm not sure if 'have_fsid' can ever be 'false' in this call.  It is
set to 'true' when handling the monmap, and it's never changed back to
'false'.  Since I don't think copy_file_range will be invoked *before*
we get the monmap, it should be safe to drop this check.  Maybe it could
be replaced it by a WARN_ON()?

Cheers,
-- 
Luis

>
>> +		if (ceph_fsid_compare(&src_fsc->client->fsid,
>> +				      &dst_fsc->client->fsid)) {
>> +			dout("Copying object across different clusters:");
>> +			dout("  src fsid: %*ph\n  dst fsid: %*ph\n",
>> +			     16, &src_fsc->client->fsid,
>> +			     16, &dst_fsc->client->fsid);
>> +			return -EXDEV;
>> +		}
>> +	}
>>  	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>>  		return -EROFS;
>>  
>> @@ -1928,7 +1943,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>>  	 * efficient).
>>  	 */
>>  
>> -	if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
>> +	if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
>>  		return -EOPNOTSUPP;
>>  
>>  	if ((src_ci->i_layout.stripe_unit != dst_ci->i_layout.stripe_unit) ||
>> @@ -2044,7 +2059,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>>  				dst_ci->i_vino.ino, dst_objnum);
>>  		/* Do an object remote copy */
>>  		err = ceph_osdc_copy_from(
>> -			&ceph_inode_to_client(src_inode)->client->osdc,
>> +			&src_fsc->client->osdc,
>>  			src_ci->i_vino.snap, 0,
>>  			&src_oid, &src_oloc,
>>  			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
