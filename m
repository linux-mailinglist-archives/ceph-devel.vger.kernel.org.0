Return-Path: <ceph-devel+bounces-1144-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CCD8C807E
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2024 06:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 413C81C20F05
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2024 04:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB09D534;
	Fri, 17 May 2024 04:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thofu.net header.i=@thofu.net header.b="eMsQurgu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CE1BA29
	for <ceph-devel@vger.kernel.org>; Fri, 17 May 2024 04:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715921257; cv=none; b=dPBgbh8/l+Q/A2FPCQhoLXrtJsph3SZXXFEwYgIcRscptGkqeuWrutFM4EAnICA3c9aToWdzL45CwwYM3d2XFSmYDjdB57sHBNNp2SAgfUoiiYXsKXeAb4tue9ujQOfrZWmu/wPzMss7EyJKquSUdXUqYCs17E214/wnAcPDEKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715921257; c=relaxed/simple;
	bh=uBxqmf4DDNAtgLHOXw9yLYFFHTd7BgSaJ2Jtvq/MBSY=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=feEJ80Adgp4PY5hRvn5LeuEDomO+3nPT4ZodVgC36r6sTHmwm6ED9UDsBRxn84nRVMILcOGJAvhhb2tTvwnS04GMeocS3o2FLRyFPmnNVRdWQnNqAOwAzOlSE9oLMxDaH+S9Ift4NxTxqArawDrScs1NBqa56Lp2QzkWznkesmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thofu.net; spf=pass smtp.mailfrom=thofu.net; dkim=pass (2048-bit key) header.d=thofu.net header.i=@thofu.net header.b=eMsQurgu; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thofu.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thofu.net
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4VgZFT5Tj1z9sW2;
	Fri, 17 May 2024 06:47:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thofu.net; s=MBO0001;
	t=1715921245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2grax2CXteYlHEX1jZhT6y2G3OixqtOYTYHzLcgEFM=;
	b=eMsQurgu2wQjAwVCoTi8aA7rF8rTYVhgtIoFv674GEYEUCOnI3gBkovnVRwqp/ExFPmwPU
	jSHmqp6sW7N0BRbNeeKzJi1Dqp7AL/l2s6/889mI+87pyreZRH+27SOo9hYGjQl4pLR0I/
	YujjeWpzMZuSclMwasoGWV1xwVh9xAzL4BK5zcBNHbpeuEOUbxeY/IfsNbNnyscEgoiJu3
	xF7hkn0XyAoXlIKAArRkl9j3jH5KERs6PiVd3iKdKbqMH3j8a8ONjHjFhyf/n/WW0ZQGvn
	vY0MZ9FMGviOYVZsWhRFFxZDz2h/LmZeHoSjKytamUbf3is6oJSNsabHBKeXZg==
Date: Fri, 17 May 2024 06:47:25 +0200 (CEST)
From: t.fuchs@thofu.net
To: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Message-ID: <432591791.529516.1715921245211@office.mailbox.org>
In-Reply-To: <8d0dd0c9-a587-4eb9-9169-26e444a27ba0@redhat.com>
References: <20240516170021.3738-1-t.fuchs@thofu.net>
 <8d0dd0c9-a587-4eb9-9169-26e444a27ba0@redhat.com>
Subject: Re: [PATCH] ceph: fix stale xattr when using read() on dir with '-o
 dirstat'
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal

Hi Xiubo,

Thanks for the response.

These are the steps I used to test the issue on a cephfs mount with the dirstat option enabled:

```
mkdir -p dir1/dir2
touch dir1/dir2/file
cat dir1
```

Output without patch applied:
```
entries:                      1
 files:                       0
 subdirs:                     1
rentries:                     2
 rfiles:                      0
 rsubdirs:                    2
rbytes:                       0
rctime:    1715919375.649629819
```

Output with patch applied:
```
entries:                      1
 files:                       0
 subdirs:                     1
rentries:                     3
 rfiles:                      1
 rsubdirs:                    2
rbytes:                       0
rctime:    1715919859.046790099
```

The unpatched code does not show the new file in the recursive
attributes.
Accessing the directory with e.g. `ls dir1` seems to update the
attributes and `cat` will return the correct information
afterwards.

Interestingly the call `mkdir -p dir1/dir2/dir3 && cat dir1` will
not count dir3 initially even with the patch but fixes itself after
a few seconds with the patch. 
This behavior is the same for `getfattr` though; hence I did not
investigate more.

Best regards,
Thorsten

> Xiubo Li <xiubli@redhat.com> hat am 17.05.2024 02:32 CEST geschrieben:
> 
>  
> Hi Thorsten,
> 
> Thanks for your patch.
> 
> BTW, could share the steps to reproduce this issue you are trying to fix ?
> 
> Maybe this worth to add a test case in ceph qa suite.
> 
> Thanks
> 
> - Xiubo
> 
> On 5/17/24 01:00, Thorsten Fuchs wrote:
> > Fixes stale recursive stats (rbytes, rentries, ...) being returned for
> > a directory after creating/deleting entries in subdirectories.
> >
> > Now `getfattr` and `cat` return the same values for the attributes.
> >
> > Signed-off-by: Thorsten Fuchs <t.fuchs@thofu.net>
> > ---
> >   fs/ceph/dir.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 0e9f56eaba1e..e3cf76660305 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -2116,12 +2116,16 @@ static ssize_t ceph_read_dir(struct file *file, char __user *buf, size_t size,
> >   	struct ceph_dir_file_info *dfi = file->private_data;
> >   	struct inode *inode = file_inode(file);
> >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > -	int left;
> > +	int left, err;
> >   	const int bufsize = 1024;
> >   
> >   	if (!ceph_test_mount_opt(ceph_sb_to_fs_client(inode->i_sb), DIRSTAT))
> >   		return -EISDIR;
> >   
> > +	err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
> > +	if (err)
> > +		return err;
> > +
> >   	if (!dfi->dir_info) {
> >   		dfi->dir_info = kmalloc(bufsize, GFP_KERNEL);
> >   		if (!dfi->dir_info)

