Return-Path: <ceph-devel+bounces-2174-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 118829D1DE4
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 03:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B135B20BED
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 02:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D91A28E3F;
	Tue, 19 Nov 2024 02:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ep+CQk8v"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1B7179A7
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731981709; cv=none; b=pQSZXZm5fCoPF1QGz6qCkVfRdabMQRmbBFsGAYwkKifEri/OPwkpUcMDAeJvrSoHeJ85NvZy35pYuaw3Wa+JLK3yWlEqaiY90QwMu/m/VL5dHZGYEZIKITp81LBvXyh/OifdITR3aEZyibyrMlxqZgJi4DPOrKjWRIFowvkhEuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731981709; c=relaxed/simple;
	bh=4CzWe3Pkngg0Rn8+xCLUS3Ji7Q6SjGFZsFlNQpLG7+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UY6LHztIPRc/2xzDky5GIVwzWEkGRzudgWarqW64VymTE6xueV7ftEs4N2kYZWWCtyzV4Q93V2Xurdmp9Rfz8YxtJ5LKf5nGS9c3aXhRiv3Tzmj+AZHFq/wSClj+/ZJjPAMqWCjwCaaSpP5DhqsOP28GdL1fUA8YBX9k/XWa93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ep+CQk8v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731981705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a8nUNLEPwNPPGxVhi+HpyrPTnv0LRBFFFV5oZ0N0j2k=;
	b=Ep+CQk8vT291U7TUifDK7c2jWGACyLj8U+rMGtOKOIHo4tqi61FTBM0itnk5H1kvt1Qubh
	UGyMNgJPhSVzwnA+wYlJQrPkvRdp66RyWkRXbTRODJRhnjUlx2cONKAKoqxRep5vsKLdFi
	WMI3JyAgPWpSJhC3kvBaodlNqXYSYc0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-gIJSTsaDPnamsGw43v6luw-1; Mon, 18 Nov 2024 21:01:44 -0500
X-MC-Unique: gIJSTsaDPnamsGw43v6luw-1
X-Mimecast-MFC-AGG-ID: gIJSTsaDPnamsGw43v6luw
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d425d1f0dbso22844326d6.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2024 18:01:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731981703; x=1732586503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8nUNLEPwNPPGxVhi+HpyrPTnv0LRBFFFV5oZ0N0j2k=;
        b=QlzFR+kwfcLE+IHUXLY1f53V1qj9m1c27CqpRW0WYmI03FZXg9FiHvJa5ksHYuUvNU
         Hns/DankJI2/9/yIBiQ1ubyLq8rEp8jXaJMo+yc/gQRkA+0FnOjUQ+ilFmHzY/BGG0np
         Grd47xuPZuDAtepRHhaDBz+kvNRE4ni99U9g4DWhxk+f3QDH2MmwLDGGA5YMDSLGHKLp
         3Xag3SdF12171HHCy+XLWJvi8UADPM3jKvqiVaGO0WL/RwXIyOV4O66gR7oz5FKIMskd
         MjctoeKCjPGtgfdjE3hM+5czPC6GTfHo6lPPkZdIw67QueYEgZko0BlODPf02Ts2b93v
         mwxA==
X-Forwarded-Encrypted: i=1; AJvYcCWb0ERVI1yulKlIKZzoVIt5qI5mg4vR2vYdeF9thI6QP1cGSuJjLGwntOayZKNOqSQ37Z0tF86rWj/v@vger.kernel.org
X-Gm-Message-State: AOJu0YzkDQ8Bm5j1Y5V20GbTzUgep1waKwArztM8pzlWMNpOQPWGo8qR
	Cq4aX6uPD4BzpgWho8VNBVPb1YnC5+/g2eWepD0Mk98eIE0hVWWnt559kyMq9EZPJZ0x6I/RfRD
	Pht9E58PfGODcMYd4BFf6mH38fMNp8WBGISajE82oH8RbhW/DW9O+3p4Kkl3HzhnbLseBK9iBoI
	+kPKb6W49tgflZsbtdrChN8GdE5+ryaNwbHA==
X-Received: by 2002:a0c:f9c8:0:b0:6d4:1a8a:ade5 with SMTP id 6a1803df08f44-6d42b916b30mr28338276d6.20.1731981703679;
        Mon, 18 Nov 2024 18:01:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFRqDulaPRW/bZrFjSc/8bcQfzDYWKud3q8xsut29HBWC/z8H85bhXSWjCX2BdSW4r970zyh5zGm19KVYSPf2c=
X-Received: by 2002:a0c:f9c8:0:b0:6d4:1a8a:ade5 with SMTP id
 6a1803df08f44-6d42b916b30mr28338076d6.20.1731981703422; Mon, 18 Nov 2024
 18:01:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241022144838.1049499-1-batrick@batbytes.com>
 <20241022144838.1049499-3-batrick@batbytes.com> <CAOi1vP_S75CpvjRG5DXinG20PUOqc3Kf+nxtRjmZekjDbM+q1g@mail.gmail.com>
In-Reply-To: <CAOi1vP_S75CpvjRG5DXinG20PUOqc3Kf+nxtRjmZekjDbM+q1g@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Mon, 18 Nov 2024 21:01:17 -0500
Message-ID: <CA+2bHPZeeA0-i-e1TyjYrvCWW+c6uWfxMqaJuehj=1T1=KV1Ng@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: correct ceph_mds_cap_peer field name
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>, Xiubo Li <xiubli@redhat.com>, 
	"open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)" <ceph-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 5:55=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Tue, Oct 22, 2024 at 4:49=E2=80=AFPM Patrick Donnelly <batrick@batbyte=
s.com> wrote:
> >
> > See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_peer f=
ield name".
> >
> > See-also: https://tracker.ceph.com/issues/66704
> > Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
> > ---
> >  fs/ceph/caps.c               | 23 ++++++++++++-----------
> >  include/linux/ceph/ceph_fs.h |  2 +-
> >  2 files changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index bed34fc11c91..88a674cf27a8 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -4086,17 +4086,17 @@ static void handle_cap_export(struct inode *ino=
de, struct ceph_mds_caps *ex,
> >         struct ceph_inode_info *ci =3D ceph_inode(inode);
> >         u64 t_cap_id;
> >         unsigned mseq =3D le32_to_cpu(ex->migrate_seq);
> > -       unsigned t_seq, t_mseq;
> > +       unsigned t_issue_seq, t_mseq;
> >         int target, issued;
> >         int mds =3D session->s_mds;
> >
> >         if (ph) {
> >                 t_cap_id =3D le64_to_cpu(ph->cap_id);
> > -               t_seq =3D le32_to_cpu(ph->seq);
> > +               t_issue_seq =3D le32_to_cpu(ph->issue_seq);
> >                 t_mseq =3D le32_to_cpu(ph->mseq);
> >                 target =3D le32_to_cpu(ph->mds);
> >         } else {
> > -               t_cap_id =3D t_seq =3D t_mseq =3D 0;
> > +               t_cap_id =3D t_issue_seq =3D t_mseq =3D 0;
> >                 target =3D -1;
> >         }
> >
> > @@ -4134,12 +4134,12 @@ static void handle_cap_export(struct inode *ino=
de, struct ceph_mds_caps *ex,
> >         if (tcap) {
> >                 /* already have caps from the target */
> >                 if (tcap->cap_id =3D=3D t_cap_id &&
> > -                   ceph_seq_cmp(tcap->seq, t_seq) < 0) {
> > +                   ceph_seq_cmp(tcap->seq, t_issue_seq) < 0) {
> >                         doutc(cl, " updating import cap %p mds%d\n", tc=
ap,
> >                               target);
> >                         tcap->cap_id =3D t_cap_id;
> > -                       tcap->seq =3D t_seq - 1;
> > -                       tcap->issue_seq =3D t_seq - 1;
> > +                       tcap->seq =3D t_issue_seq - 1;
> > +                       tcap->issue_seq =3D t_issue_seq - 1;
> >                         tcap->issued |=3D issued;
> >                         tcap->implemented |=3D issued;
> >                         if (cap =3D=3D ci->i_auth_cap) {
> > @@ -4154,7 +4154,7 @@ static void handle_cap_export(struct inode *inode=
, struct ceph_mds_caps *ex,
> >                 int flag =3D (cap =3D=3D ci->i_auth_cap) ? CEPH_CAP_FLA=
G_AUTH : 0;
> >                 tcap =3D new_cap;
> >                 ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
> > -                            t_seq - 1, t_mseq, (u64)-1, flag, &new_cap=
);
> > +                            t_issue_seq - 1, t_mseq, (u64)-1, flag, &n=
ew_cap);
> >
> >                 if (!list_empty(&ci->i_cap_flush_list) &&
> >                     ci->i_auth_cap =3D=3D tcap) {
> > @@ -4268,14 +4268,14 @@ static void handle_cap_import(struct ceph_mds_c=
lient *mdsc,
> >                 doutc(cl, " remove export cap %p mds%d flags %d\n",
> >                       ocap, peer, ph->flags);
> >                 if ((ph->flags & CEPH_CAP_FLAG_AUTH) &&
> > -                   (ocap->seq !=3D le32_to_cpu(ph->seq) ||
> > +                   (ocap->seq !=3D le32_to_cpu(ph->issue_seq) ||
> >                      ocap->mseq !=3D le32_to_cpu(ph->mseq))) {
> >                         pr_err_ratelimited_client(cl, "mismatched seq/m=
seq: "
> >                                         "%p %llx.%llx mds%d seq %d mseq=
 %d"
> >                                         " importer mds%d has peer seq %=
d mseq %d\n",
> >                                         inode, ceph_vinop(inode), peer,
> >                                         ocap->seq, ocap->mseq, mds,
> > -                                       le32_to_cpu(ph->seq),
> > +                                       le32_to_cpu(ph->issue_seq),
> >                                         le32_to_cpu(ph->mseq));
> >                 }
> >                 ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_=
RELEASE));
> > @@ -4350,7 +4350,7 @@ void ceph_handle_caps(struct ceph_mds_session *se=
ssion,
> >         struct ceph_snap_realm *realm =3D NULL;
> >         int op;
> >         int msg_version =3D le16_to_cpu(msg->hdr.version);
> > -       u32 seq, mseq;
> > +       u32 seq, mseq, issue_seq;
> >         struct ceph_vino vino;
> >         void *snaptrace;
> >         size_t snaptrace_len;
> > @@ -4375,6 +4375,7 @@ void ceph_handle_caps(struct ceph_mds_session *se=
ssion,
> >         vino.snap =3D CEPH_NOSNAP;
> >         seq =3D le32_to_cpu(h->seq);
> >         mseq =3D le32_to_cpu(h->migrate_seq);
> > +       issue_seq =3D le32_to_cpu(h->issue_seq);
> >
> >         snaptrace =3D h + 1;
> >         snaptrace_len =3D le32_to_cpu(h->snap_trace_len);
> > @@ -4598,7 +4599,7 @@ void ceph_handle_caps(struct ceph_mds_session *se=
ssion,
> >                 cap->cap_id =3D le64_to_cpu(h->cap_id);
> >                 cap->mseq =3D mseq;
> >                 cap->seq =3D seq;
> > -               cap->issue_seq =3D seq;
> > +               cap->issue_seq =3D issue_seq;
>
> Hi Patrick,
>
> This isn't just a rename -- a different field is decoded and assigned
> to cap->issue_seq now.  What is the impact of this change and should it
> be mentioned in the commit message?

You are right. This change slipped in by accident with some other
changes I have not yet pushed. I will revert this one.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


