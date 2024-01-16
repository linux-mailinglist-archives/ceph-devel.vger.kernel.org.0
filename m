Return-Path: <ceph-devel+bounces-531-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CFD82ECD8
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 11:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED7E22851C4
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 10:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBADC134DF;
	Tue, 16 Jan 2024 10:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eOKzGpwB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB81613AC0
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 10:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705401724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCmVD572rxDmB529Om4/gzVdka+eFdJrrNBDXwfpJqg=;
	b=eOKzGpwBBJhGeqsNcWalJwetygFl0gU8fdfDNvzEu5jKrCxUADErHQuRTJROj9e242jeF2
	N7QwUU5wsHDLxgBpn+/DHie6dV7aMepipG4IGroI0dccmtVRloLeyIyYWnKGxYK7XEZJCJ
	wKbj6RE4J0sl+KyLZWJXY2qtq9y0jfA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-wPFy5SM9P96IANL7b4qTGQ-1; Tue, 16 Jan 2024 05:42:03 -0500
X-MC-Unique: wPFy5SM9P96IANL7b4qTGQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B91FA85A58F;
	Tue, 16 Jan 2024 10:42:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B9B47492BC7;
	Tue, 16 Jan 2024 10:42:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <f535be3c-3d02-4a13-8aaf-5c634ffa218b@redhat.com>
References: <f535be3c-3d02-4a13-8aaf-5c634ffa218b@redhat.com> <2546440.1705327638@warthog.procyon.org.uk>
To: Xiubo Li <xiubli@redhat.com>
Cc: dhowells@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
    Greg Farnum <gfarnum@redhat.com>,
    Venky Shankar <vshankar@redhat.com>,
    Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: Modifying and fixing(?) the per-inode snap handling in ceph
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2578304.1705401721.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jan 2024 10:42:01 +0000
Message-ID: <2578305.1705401721@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Xiubo Li <xiubli@redhat.com> wrote:

> Please note the 'ceph_cap_snap' struct is orient to the MDS daemons in
> cephfs and for metadata only.  While the 'ceph_snap_context' struct is
> orient to the ceph Rados for data only instead.

That doesn't seem to be how it is implemented, though.  Looking at the
writeback code, the ordered list of snaps to be written back *is* the
ceph_cap_snap list.  The writeback code goes through the list in order,
writing out the data associated with the snapc that is the ->context for e=
ach
capsnap.  When a new snapshot occurs, the snap notification service code
allocates and queues a new capsnap on each inode.  Is there any reason tha=
t
cannot be done lazily?

Also, it appears there may be an additional bug here: If memory allocation
fails when allocating a new capsnap in queue_realm_cap_snaps(), it abandon=
s
the process (not unreasonably), but leaves a bunch of inodes with their ol=
d
capsnaps.  If you can do this lazily, this can be better handled in the wr=
ite
routines where user interaction can be bounced.

> As I mentioned above once a page/folio set the 'ceph_snap_context' struc=
t it
> shouldn't change any more.

Until the page has been cleaned, I presume.

> Then could you explain how to pass the snapshot set to ceph Rados when
> flushing each dirty page/folio ?

The netfs_group pointer passed into netfs_write_group() is stored in the
netfs_io_request struct and is thus accessible by the filesystem.  I've
attached the three functions involved below.  Note that this is a work in
progress and will most certainly require further changes.  It's also untes=
ted
as I haven't got it to a stage that I can test this part of the code yet.

> I don't understand how to bind the 'ceph_cap_snap' struct to dirty pages
> here.

Point folio->private at it and take a ref on it, much as it is currently d=
oing
for snapc.  The capsnap->context points to snapc and currently folio->priv=
ate
points to the snapc and then in writeback, and currently we take the conte=
xt
snapc from the capsnap and iterate over all the folios on that inode looki=
ng
for any with a private pointer that matches the snapc.  We could store the
capsnap pointer there instead and iterate looking for that.

-~-

I've pushed my patches out to:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dceph-iter

if you want a look.  Note that the top 7 patches are the ones in flux at t=
he
moment while I try and write the netfs helpers for the ceph filesystem.  D=
on't
expect any of those to compile.

Actually, I'd appreciate it if you could have a look at the patches up to
"rbd: Use ceph_databuf_enc_start/stop()".  Those are almost completely don=
e,
though with one exception.  There's one bit in RBD that still needs dealin=
g
with (marked with a #warn and an "[INCOMPLETE]" marked in the patch subjec=
t) -
but RBD does otherwise work.

The aim is to remove all the different data types, except for two: one whe=
re
an iov_iter is provided (such as an ITER_XARRAY referring directly to the
pagecache) and one where we have a "ceph_databuf" with a bvec[].  Ideally,
there would only be one, but I'll see if I can manage that.

David
---
/*
 * Handle the termination of a write to the server.
 */
static void ceph_write_terminated(struct netfs_io_subrequest *subreq, int =
err)
{
	struct ceph_io_subrequest *csub =3D
		container_of(subreq, struct ceph_io_subrequest, sreq);
	struct ceph_io_request *creq =3D csub->creq;
	struct ceph_osd_request *req =3D csub->req;
	struct inode *inode =3D creq->rreq.inode;
	struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
	struct ceph_client *cl =3D ceph_inode_to_client(inode);
	struct ceph_inode_info *ci =3D ceph_inode(inode);

	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
				  req->r_end_latency, subreq->len, err);

	if (err !=3D 0) {
		doutc(cl, "sync_write osd write returned %d\n", err);
		/* Version changed! Must re-do the rmw cycle */
		if ((creq->rmw_assert_version && (err =3D=3D -ERANGE || err =3D=3D -EOVE=
RFLOW)) ||
		    (!creq->rmw_assert_version && err =3D=3D -EEXIST)) {
			/* We should only ever see this on a rmw */
			WARN_ON_ONCE(!test_bit(NETFS_RREQ_RMW, &ci->netfs.flags));

			/* The version should never go backward */
			WARN_ON_ONCE(err =3D=3D -EOVERFLOW);

			/* FIXME: limit number of times we loop? */
			set_bit(NETFS_RREQ_REPEAT_RMW, &ci->netfs.flags);
		}
		ceph_set_error_write(ci);
	} else {
		ceph_clear_error_write(ci);
	}

	csub->req =3D NULL;
	ceph_osdc_put_request(req);
	netfs_subreq_terminated(subreq, len, err);
}

static void ceph_upload_to_server(struct netfs_io_subrequest *subreq)
{
	struct ceph_io_subrequest *csub =3D
		container_of(subreq, struct ceph_io_subrequest, sreq);
	struct ceph_osd_request *req =3D csub->req;
	struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(subreq->rreq->inod=
e);
	struct ceph_osd_client *osdc =3D &fsc->client->osdc;

	trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
	ceph_osdc_start_request(osdc, req);
}

/*
 * Set up write requests for a writeback slice.  We need to add a write re=
quest
 * for each write we want to make.
 */
void ceph_create_write_requests(struct netfs_io_request *wreq, loff_t star=
t, size_t remain)
{
	struct netfs_io_subrequest *subreq;
	struct ceph_io_subrequest *csub;
	struct ceph_snap_context *snapc =3D
		container_of(wreq->group, struct ceph_snap_context, group);
	struct inode *inode =3D wreq->inode;
	struct ceph_inode_info *ci =3D ceph_inode(inode);
	struct ceph_fs_client *fsc =3D
		ceph_inode_to_fs_client(inode);
	struct ceph_client *cl =3D ceph_inode_to_client(inode);
	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
	struct ceph_osd_request *req;
	struct timespec64 mtime =3D current_time(inode);
	bool rmw =3D test_bit(NETFS_RREQ_RMW, &ci->netfs.flags);

	doutc(cl, "create_write_reqs on inode %p %lld~%zu snapc %p seq %lld\n",
	      inode, start, remain, snapc, snapc->seq);

	do {
		unsigned long long llpart;
		size_t part =3D remain;
		u64 assert_ver =3D 0;
		u64 objnum, objoff;

		subreq =3D netfs_create_write_request(wreq, NETFS_UPLOAD_TO_SERVER,
						    start, remain, NULL);
		if (!subreq) {
			wreq->error =3D -ENOMEM;
			break;
		}

		csub =3D container_of(subreq, struct ceph_io_subrequest, sreq);

		/* clamp the length to the end of first object */
		ceph_calc_file_object_mapping(&ci->i_layout, start, remain,
					      &objnum, &objoff, &part);

		llpart =3D part;
		doutc(cl, "create_write_reqs ino %llx %lld~%zu part %lld~%llu -- %srmw\n=
",
		      ci->i_vino.ino, start, remain, start, llpart, rmw ? "" : "no ");

		req =3D ceph_osdc_new_request(osdc, &ci->i_layout,
					    ci->i_vino, start, &llpart,
					    rmw ? 1 : 0, rmw ? 2 : 1,
					    CEPH_OSD_OP_WRITE,
					    CEPH_OSD_FLAG_WRITE,
					    snapc, ci->i_truncate_seq,
					    ci->i_truncate_size, false);
		if (IS_ERR(req)) {
			wreq->error =3D PTR_ERR(req);
			break;
		}

		part =3D llpart;
		doutc(cl, "write op %lld~%zu\n", start, part);
		osd_req_op_extent_osd_iter(req, 0, &subreq->io_iter);
		req->r_inode =3D inode;
		req->r_mtime =3D mtime;
		req->subreq =3D subreq;
		csub->req =3D req;

		/*
		 * If we're doing an RMW cycle, set up an assertion that the
		 * remote data hasn't changed.  If we don't have a version
		 * number, then the object doesn't exist yet.  Use an exclusive
		 * create instead of a version assertion in that case.
		 */
		if (rmw) {
			if (assert_ver) {
				osd_req_op_init(req, 0, CEPH_OSD_OP_ASSERT_VER, 0);
				req->r_ops[0].assert_ver.ver =3D assert_ver;
			} else {
				osd_req_op_init(req, 0, CEPH_OSD_OP_CREATE,
						CEPH_OSD_OP_FLAG_EXCL);
			}
		}

		ceph_upload_to_server(req);

		start +=3D part;
		remain -=3D part;
	} while (remain > 0 && !wreq->error);

	dout("create_write_reqs returning %d\n", wreq->error);
}


