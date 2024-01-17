Return-Path: <ceph-devel+bounces-560-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B45F82FECE
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 03:29:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E94E1C23D00
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jan 2024 02:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F55663D5;
	Wed, 17 Jan 2024 02:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eb2X5XSI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6C6613C
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jan 2024 02:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705458534; cv=none; b=PaD/mVos3DQVdRPGkvy3HO8u5L6q9YZCsfi5b1bs0vySkNWavByBuxdXdWPuXPMCuoF8vDIbvN1IvtYa+1x5Kg8Ytxy84swvwdO8j0yrY4K6UDWIJ538k2QrrnEFEwn6on5D1K2dj4yVBBOJ8pcHA5jX3d/UJfLuWKbHQrNPDAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705458534; c=relaxed/simple;
	bh=36PJ3ZML9plelV63bMtSKitKUT1IhDWmGz2T4ZAG/fM=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=IfYxzpzUoR1lQd3azFJ+NlOZ/6VvF8T7ffUnIM/AK+Jen6ojwIN1B0JIcCeZQdlS+kWUpvzQ9brSHEHWYj9ImptrsrY+pI7PEpDB0Rd86fMbu2a27jeJGfLa+1wHpfcCd3hIpYX0AGJhUR3kVsv6oBaPi4C/FtnnlGzCHO20nsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eb2X5XSI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705458531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjSfEMSipjAp2UtltaeYSDcGU7NWb4RuHqfHGbQFX7U=;
	b=Eb2X5XSI8ZNX+pJJwUC/hmQ7OK6gXDqyoCSDdCiyD4U/Nvc/feSv9IZeFckoXHWFlouk2G
	jazRhAYCfcnLnPeJPBIYFKd40OgjBS3L5pwWSI3Tzm4fMEA99lMbx+ncZyvP6tDKvD9yVQ
	qFYemRanq+Ds+F5I3sOS96bHOtfq/Is=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-8_2d_fYKMl2O2PXqFEFELQ-1; Tue, 16 Jan 2024 21:28:45 -0500
X-MC-Unique: 8_2d_fYKMl2O2PXqFEFELQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1d5e12eb40dso13336685ad.1
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 18:28:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705458524; x=1706063324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hjSfEMSipjAp2UtltaeYSDcGU7NWb4RuHqfHGbQFX7U=;
        b=L8V4Ne+pqvewJ3Xoanjq9oisLrVrJrNGTtwu/gTmeH8apXsyjKG6OJ4P7tknUkJGPp
         aq12tpNSzuHKjT0P+IjpnqtNS+FgjhFBjPNdDWUNVOjZWl63Ap9yRJLTrU5Edw5xMeKZ
         shhWtCUqvjR0BeCp8pmRp0RNPN/bUw7RPpQezRydbRSDc8AMXp3y33D//qoijgpFL8Y7
         91gqpj/zbpfjPO9/4b0Oxvk9xsAkO/nsTZEtVtbhwy1ER6qmof+VTQoJvq+qDCZCEH6y
         8wFyI49HNt+1pu7Z5BNmpjEsabjlNNcKvwzKw1EAzC6wyFMs/tldl/9vRJ7wf/bnBwuZ
         SmVQ==
X-Gm-Message-State: AOJu0YwR/J00uee8ZtuG2DQqDPn57y3ca2rByCAaujAul+rQ4HgDfjIg
	I3hrKn5JhleO2mKOK32eSCkJF56hqWQpp056ok5gc3BWemf46ebhlReq7eOsOIj7kv0xqPiU/o7
	8kOnLG4p8J8Gm6DRGJHZhIZzMRuH4YAifK0CXW/4IMF6CsX98ldZUJjuOZglJ4eICjc4=
X-Received: by 2002:a17:90b:3442:b0:28d:c2ec:8950 with SMTP id lj2-20020a17090b344200b0028dc2ec8950mr220007pjb.2.1705458523763;
        Tue, 16 Jan 2024 18:28:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH9Sk5v9aQKPJ5Dt+3ReZouhg/KDvX533hBJ5Visht8XcVIF0sJYXjPlm9r3WdGww4Hkj6+Uw==
X-Received: by 2002:a17:90b:3442:b0:28d:c2ec:8950 with SMTP id lj2-20020a17090b344200b0028dc2ec8950mr219997pjb.2.1705458523396;
        Tue, 16 Jan 2024 18:28:43 -0800 (PST)
Received: from [10.72.112.211] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id sw11-20020a17090b2c8b00b0028bdc73edfcsm14819986pjb.12.2024.01.16.18.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jan 2024 18:28:43 -0800 (PST)
Message-ID: <e871e640-bf26-4d12-bd98-e80be58641fc@redhat.com>
Date: Wed, 17 Jan 2024 10:28:38 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Modifying and fixing(?) the per-inode snap handling in ceph
Content-Language: en-US
To: David Howells <dhowells@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, Greg Farnum <gfarnum@redhat.com>,
 Venky Shankar <vshankar@redhat.com>, Jeff Layton <jlayton@kernel.org>,
 ceph-devel@vger.kernel.org
References: <f535be3c-3d02-4a13-8aaf-5c634ffa218b@redhat.com>
 <2546440.1705327638@warthog.procyon.org.uk>
 <2578305.1705401721@warthog.procyon.org.uk>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <2578305.1705401721@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/16/24 18:42, David Howells wrote:
> Xiubo Li <xiubli@redhat.com> wrote:
>
>> Please note the 'ceph_cap_snap' struct is orient to the MDS daemons in
>> cephfs and for metadata only.  While the 'ceph_snap_context' struct is
>> orient to the ceph Rados for data only instead.
> That doesn't seem to be how it is implemented, though.  Looking at the
> writeback code, the ordered list of snaps to be written back *is* the
> ceph_cap_snap list.  The writeback code goes through the list in order,
> writing out the data associated with the snapc that is the ->context for each
> capsnap.

Did you see the code in 
https://github.com/ceph/ceph-client/blob/for-linus/fs/ceph/addr.c#L1065-L1076 
? And later when writing the page out it will use the 'snapc' which must 
equal to the page's static snapc.

While when the 'ci->ceph_cap_snap' list is empty the 
'get_oldest_context()' will return the global realm's snapc instead. The 
global realm will always exist from beginning.


>   When a new snapshot occurs, the snap notification service code
> allocates and queues a new capsnap on each inode.  Is there any reason that
> cannot be done lazily?

As you know cephfs snapshot is already in lazy mode and very fast. IMO 
it need to finalize the size, mtime, etc for a cap_snap asap.

> Also, it appears there may be an additional bug here: If memory allocation
> fails when allocating a new capsnap in queue_realm_cap_snaps(), it abandons
> the process (not unreasonably), but leaves a bunch of inodes with their old
> capsnaps.  If you can do this lazily, this can be better handled in the write
> routines where user interaction can be bounced.

Yeah, in corner case this really could fail and we need to improve IMO. 
But if we defer doing this always is not a good idea because during this 
time the size could be changed a lot.

>
>> As I mentioned above once a page/folio set the 'ceph_snap_context' struct it
>> shouldn't change any more.
> Until the page has been cleaned, I presume.

Correct.

>
>> Then could you explain how to pass the snapshot set to ceph Rados when
>> flushing each dirty page/folio ?
> The netfs_group pointer passed into netfs_write_group() is stored in the
> netfs_io_request struct and is thus accessible by the filesystem.  I've
> attached the three functions involved below.  Note that this is a work in
> progress and will most certainly require further changes.  It's also untested
> as I haven't got it to a stage that I can test this part of the code yet.
>
>> I don't understand how to bind the 'ceph_cap_snap' struct to dirty pages
>> here.
> Point folio->private at it and take a ref on it, much as it is currently doing
> for snapc.  The capsnap->context points to snapc and currently folio->private
> points to the snapc and then in writeback, and currently we take the context
> snapc from the capsnap and iterate over all the folios on that inode looking
> for any with a private pointer that matches the snapc.  We could store the
> capsnap pointer there instead and iterate looking for that.
>
> -~-
>
> I've pushed my patches out to:
>
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=ceph-iter
>
> if you want a look.  Note that the top 7 patches are the ones in flux at the
> moment while I try and write the netfs helpers for the ceph filesystem.  Don't
> expect any of those to compile.
>
> Actually, I'd appreciate it if you could have a look at the patches up to
> "rbd: Use ceph_databuf_enc_start/stop()".  Those are almost completely done,
> though with one exception.  There's one bit in RBD that still needs dealing
> with (marked with a #warn and an "[INCOMPLETE]" marked in the patch subject) -
> but RBD does otherwise work.
>
> The aim is to remove all the different data types, except for two: one where
> an iov_iter is provided (such as an ITER_XARRAY referring directly to the
> pagecache) and one where we have a "ceph_databuf" with a bvec[].  Ideally,
> there would only be one, but I'll see if I can manage that.

Okay, I will try to read these patches this week. Let me see how do they 
work.

Thanks David

- Xiubo


> David
> ---
> /*
>   * Handle the termination of a write to the server.
>   */
> static void ceph_write_terminated(struct netfs_io_subrequest *subreq, int err)
> {
> 	struct ceph_io_subrequest *csub =
> 		container_of(subreq, struct ceph_io_subrequest, sreq);
> 	struct ceph_io_request *creq = csub->creq;
> 	struct ceph_osd_request *req = csub->req;
> 	struct inode *inode = creq->rreq.inode;
> 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
> 	struct ceph_client *cl = ceph_inode_to_client(inode);
> 	struct ceph_inode_info *ci = ceph_inode(inode);
>
> 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
> 				  req->r_end_latency, subreq->len, err);
>
> 	if (err != 0) {
> 		doutc(cl, "sync_write osd write returned %d\n", err);
> 		/* Version changed! Must re-do the rmw cycle */
> 		if ((creq->rmw_assert_version && (err == -ERANGE || err == -EOVERFLOW)) ||
> 		    (!creq->rmw_assert_version && err == -EEXIST)) {
> 			/* We should only ever see this on a rmw */
> 			WARN_ON_ONCE(!test_bit(NETFS_RREQ_RMW, &ci->netfs.flags));
>
> 			/* The version should never go backward */
> 			WARN_ON_ONCE(err == -EOVERFLOW);
>
> 			/* FIXME: limit number of times we loop? */
> 			set_bit(NETFS_RREQ_REPEAT_RMW, &ci->netfs.flags);
> 		}
> 		ceph_set_error_write(ci);
> 	} else {
> 		ceph_clear_error_write(ci);
> 	}
>
> 	csub->req = NULL;
> 	ceph_osdc_put_request(req);
> 	netfs_subreq_terminated(subreq, len, err);
> }
>
> static void ceph_upload_to_server(struct netfs_io_subrequest *subreq)
> {
> 	struct ceph_io_subrequest *csub =
> 		container_of(subreq, struct ceph_io_subrequest, sreq);
> 	struct ceph_osd_request *req = csub->req;
> 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(subreq->rreq->inode);
> 	struct ceph_osd_client *osdc = &fsc->client->osdc;
>
> 	trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
> 	ceph_osdc_start_request(osdc, req);
> }
>
> /*
>   * Set up write requests for a writeback slice.  We need to add a write request
>   * for each write we want to make.
>   */
> void ceph_create_write_requests(struct netfs_io_request *wreq, loff_t start, size_t remain)
> {
> 	struct netfs_io_subrequest *subreq;
> 	struct ceph_io_subrequest *csub;
> 	struct ceph_snap_context *snapc =
> 		container_of(wreq->group, struct ceph_snap_context, group);
> 	struct inode *inode = wreq->inode;
> 	struct ceph_inode_info *ci = ceph_inode(inode);
> 	struct ceph_fs_client *fsc =
> 		ceph_inode_to_fs_client(inode);
> 	struct ceph_client *cl = ceph_inode_to_client(inode);
> 	struct ceph_osd_client *osdc = &fsc->client->osdc;
> 	struct ceph_osd_request *req;
> 	struct timespec64 mtime = current_time(inode);
> 	bool rmw = test_bit(NETFS_RREQ_RMW, &ci->netfs.flags);
>
> 	doutc(cl, "create_write_reqs on inode %p %lld~%zu snapc %p seq %lld\n",
> 	      inode, start, remain, snapc, snapc->seq);
>
> 	do {
> 		unsigned long long llpart;
> 		size_t part = remain;
> 		u64 assert_ver = 0;
> 		u64 objnum, objoff;
>
> 		subreq = netfs_create_write_request(wreq, NETFS_UPLOAD_TO_SERVER,
> 						    start, remain, NULL);
> 		if (!subreq) {
> 			wreq->error = -ENOMEM;
> 			break;
> 		}
>
> 		csub = container_of(subreq, struct ceph_io_subrequest, sreq);
>
> 		/* clamp the length to the end of first object */
> 		ceph_calc_file_object_mapping(&ci->i_layout, start, remain,
> 					      &objnum, &objoff, &part);
>
> 		llpart = part;
> 		doutc(cl, "create_write_reqs ino %llx %lld~%zu part %lld~%llu -- %srmw\n",
> 		      ci->i_vino.ino, start, remain, start, llpart, rmw ? "" : "no ");
>
> 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
> 					    ci->i_vino, start, &llpart,
> 					    rmw ? 1 : 0, rmw ? 2 : 1,
> 					    CEPH_OSD_OP_WRITE,
> 					    CEPH_OSD_FLAG_WRITE,
> 					    snapc, ci->i_truncate_seq,
> 					    ci->i_truncate_size, false);
> 		if (IS_ERR(req)) {
> 			wreq->error = PTR_ERR(req);
> 			break;
> 		}
>
> 		part = llpart;
> 		doutc(cl, "write op %lld~%zu\n", start, part);
> 		osd_req_op_extent_osd_iter(req, 0, &subreq->io_iter);
> 		req->r_inode = inode;
> 		req->r_mtime = mtime;
> 		req->subreq = subreq;
> 		csub->req = req;
>
> 		/*
> 		 * If we're doing an RMW cycle, set up an assertion that the
> 		 * remote data hasn't changed.  If we don't have a version
> 		 * number, then the object doesn't exist yet.  Use an exclusive
> 		 * create instead of a version assertion in that case.
> 		 */
> 		if (rmw) {
> 			if (assert_ver) {
> 				osd_req_op_init(req, 0, CEPH_OSD_OP_ASSERT_VER, 0);
> 				req->r_ops[0].assert_ver.ver = assert_ver;
> 			} else {
> 				osd_req_op_init(req, 0, CEPH_OSD_OP_CREATE,
> 						CEPH_OSD_OP_FLAG_EXCL);
> 			}
> 		}
>
> 		ceph_upload_to_server(req);
>
> 		start += part;
> 		remain -= part;
> 	} while (remain > 0 && !wreq->error);
>
> 	dout("create_write_reqs returning %d\n", wreq->error);
> }
>


