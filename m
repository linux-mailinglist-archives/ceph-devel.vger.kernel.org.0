Return-Path: <ceph-devel+bounces-3408-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBFEB2226D
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 11:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62243189C8F5
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 09:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3DC2DCF7C;
	Tue, 12 Aug 2025 09:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MzxtelQk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16182E7628
	for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754989640; cv=none; b=QpPm/FgijYKZxqbmSXNeSr5KO+pWDul0767jWmsxeTkIlKeVaRX6BAaqyvvP+GQWcg6UVDWNGr8M9QN0dH26j+Ef2vZzjbLs83jvHk1AuGmrP9V9zt0VLDpKFYfvDhAacQctWY7SQjBVq/YJXPq/AbpQnUzlm2ZhGMokw208S0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754989640; c=relaxed/simple;
	bh=jBa8QlNQLfMd0qeeYKGmF16GJzviVnykiEWgJtTk6V0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IvdRD/TUjyjhTnOmd+/atlpLhBoBxdsQQVvAR2ACWCYtpjpu3MvvFBsQKNIdWh+MrZfgXpArwgvSpfiuClCQZA3DZMKDDceH0Kyl56/8SUgSckFHptteOepWk0Rigtp5NjAH2mGJsjIg1w/rvmYGx/CpGyMUacV2INgCJhp5ymE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MzxtelQk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754989637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rutRIXHAPRWJ6z84S1clvZ1Wylqad9SKaRZUqiEkzQ=;
	b=MzxtelQkaMWD00NGfrZbLb16PgbWSZCplKvV5lOSKjImvjnUWZ/dPXzHGE4r9XU/mAVpoD
	HXesjSypOtE8sh2ItYSwHC2eHewxT4q5FGIK2fLECKBNlOXWw+eiFIdF+1ZvWTX/lll0Aj
	4tB5U80JHQsIUbxgcjfJ+cCEPK1rXhY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-vaWJk2OdMKSfNfDnxaFrOw-1; Tue, 12 Aug 2025 05:07:16 -0400
X-MC-Unique: vaWJk2OdMKSfNfDnxaFrOw-1
X-Mimecast-MFC-AGG-ID: vaWJk2OdMKSfNfDnxaFrOw_1754989635
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-31eec17b5acso6179602a91.2
        for <ceph-devel@vger.kernel.org>; Tue, 12 Aug 2025 02:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754989635; x=1755594435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rutRIXHAPRWJ6z84S1clvZ1Wylqad9SKaRZUqiEkzQ=;
        b=STa8qAXGt2mQJnTDSKtCVg7EQld11XxjvtO6vuIut5ZTr/wQ8m6wzKOrSW4oABRxkX
         inEVvsrA/V5Q/up2uODWU1Gj/lh+7r1hZ71+2CE39dm/QNhfeW0V7MsydBJBpLmxI0jp
         uywqUi59SEAJat9ed75hZxr4YejMtPMPW5GUNZ8w+r6wpj2OexrEA3BT30eraNF4XyUb
         lGN0OWEqYY3KulgYuxgsVIB5e0+i5Xd5qu6J0rP6L+sCt9w9OVhXC1zfJHCVm6I5olwR
         gTFOvzzJK1FG7y0PUg9rNgz5RgR6iza/obRMCla23JdzFEII2FGSibX4mN85z7wqmXgP
         LAsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUDwvQ+GhmxM9WzttUYQg4ArPiSYeLuqHeH4nX1GuCd6V3v+HBggtn+JNJmPKj+2DekXNGQEO8ldj1@vger.kernel.org
X-Gm-Message-State: AOJu0YyIO81eO5hQS/LUFmeO92NzROQEcHb5zxBFpkuV5OYAORKfbm9a
	prHd4OCfvc1GS6X2fbQmsJlXzH5QJQYq0pFRKGxs5bllvTGl5dVGsWVb3NsQBQiNLS32baQOl+T
	SyZYAgu2XJk70uwELGRKVGaopwGPbGLlw5L5kYc27UrEEN+vL/dQWNH/oHktv5LJK044WYD9luU
	BzoAonGHHtGJYQfLCGdbw03ItjyKyIqOrK7wjr
X-Gm-Gg: ASbGncv3PjHp0aBZBfV8oWBl0wg6oAxMT1Cx6eP6N4O481K/IMfUsBgFAKAM/efhxlJ
	9v+8Z/bXI4Wv+Ia2XaUjjLEdb4bzEqTdcMkN5fj4xQbUjy6Dji50+46W00wbPrE614+h7w1MJ4n
	ABq2p0uhfIaxyDiv3h3NqiFw==
X-Received: by 2002:a17:90b:2e84:b0:313:f6fa:5bca with SMTP id 98e67ed59e1d1-321c0b2b72fmr2998057a91.22.1754989634891;
        Tue, 12 Aug 2025 02:07:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGk1pRcj8sOmkRTf7bU0IP/Nq61NDrOEh7kIRK+n3hmso/d/K1V8N+Q4baqOHw9cv54FJOqVDQncQaSX5OB6w4=
X-Received: by 2002:a17:90b:2e84:b0:313:f6fa:5bca with SMTP id
 98e67ed59e1d1-321c0b2b72fmr2998026a91.22.1754989634342; Tue, 12 Aug 2025
 02:07:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729170240.118794-1-khiremat@redhat.com> <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com> <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
 <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com>
In-Reply-To: <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com>
From: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date: Tue, 12 Aug 2025 14:37:03 +0530
X-Gm-Features: Ac12FXyrJ_qSg4ybG28cjNn_zTzUEvgARBY4rGwO-EDqsUhGKjmRlfuB5rxThCU
Message-ID: <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix multifs mds auth caps issue
To: Viacheslav Dubeyko <slava.dubeyko@ibm.com>
Cc: Alex Markuze <amarkuze@redhat.com>, Venky Shankar <vshankar@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Patrick Donnelly <pdonnell@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 2:50=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-08-06 at 14:23 +0530, Kotresh Hiremath Ravishankar wrote:
> > On Sat, Aug 2, 2025 at 1:=E2=80=8A31 AM Viacheslav Dubeyko <Slava.=E2=
=80=8ADubeyko@=E2=80=8Aibm.=E2=80=8Acom> wrote: > > On Fri, 2025-08-01 at 2=
2:=E2=80=8A59 +0530, Kotresh Hiremath Ravishankar wrote: > > > > Hi, > > > =
> 1. I will modify the commit message
> >
> > On Sat, Aug 2, 2025 at 1:31=E2=80=AFAM Viacheslav Dubeyko <Slava.Dubeyk=
o@ibm.com> wrote:
> > >
> > > On Fri, 2025-08-01 at 22:59 +0530, Kotresh Hiremath Ravishankar wrote=
:
> > > >
> > > > Hi,
> > > >
> > > > 1. I will modify the commit message to clearly explain the issue in=
 the next revision.
> > > > 2. The maximum possible length for the fsname is not defined in mds=
 side. I didn't find any restriction imposed on the length. So we need to l=
ive with it.
> > >
> > > We have two constants in Linux kernel [1]:
> > >
> > > #define NAME_MAX         255    /* # chars in a file name */
> > > #define PATH_MAX        4096    /* # chars in a path name including n=
ul */
> > >
> > > I don't think that fsname can be bigger than PATH_MAX.
> >
> > As I had mentioned earlier, the CephFS server side code is not restrict=
ing the filesystem name
> > during creation. I validated the creation of a filesystem name with a l=
ength of 5000.
> > Please try the following.
> >
> > [kotresh@fedora build]$ alpha_str=3D$(< /dev/urandom tr -dc 'a-zA-Z' | =
head -c 5000)
> > [kotresh@fedora build]$ ceph fs new $alpha_str cephfs_data cephfs_metad=
ata
> > [kotresh@fedora build]$ bin/ceph fs ls
> >
> > So restricting the fsname length in the kclient would likely cause issu=
es. If we need to enforce the limitation, I think, it should be done at ser=
ver side first and it=E2=80=99s a separate effort.
> >
>
> I am not sure that Linux kernel is capable to digest any name bigger than
> NAME_MAX. Are you sure that we can pass xfstests with filesystem name big=
ger
> than NAME_MAX? Another point here that we can put buffer with name inline
> into struct ceph_mdsmap if the name cannot be bigger than NAME_MAX, for e=
xample.
> In this case we don't need to allocate fs_name memory for every
> ceph_mdsmap_decode() call.

Well, I haven't tried xfstests with a filesystem name bigger than
NAME_MAX. But I did try mounting a ceph filesystem name bigger than
NAME_MAX and it works.
But mounting a ceph filesystem name bigger than PATH_MAX didn't work.
Note that the creation of a ceph filesystem name bigger than PATH_MAX
works and
mounting with the same using fuse client works as well.

I was going through ceph kernel client code, historically, the
filesystem name is stored as a char pointer. The filesystem name from
mount options is stored
into 'struct ceph_mount_options' in 'ceph_parse_new_source' and the
same is used to compare against the fsmap received from the mds in
'ceph_mdsc_handle_fsmap'

struct ceph_mount_options {
    ...
    char *mds_namespace;  /* default NULL */
    ...
};

I am not sure what's the right approach to choose here. In kclient,
assuming ceph fsname not to be bigger than PATH_MAX seems to be safe
as the kclient today is
not able to mount the ceph fsname bigger than PATH_MAX. I also
observed that the kclient failed to mount the ceph fsname with length
little less than
PATH_MAX (4090). So it's breaking somewhere with the entire path
component being considered. Anyway, I will open the discussion to
everyone here.
If we are restricting the max fsname length, we need to restrict it
while creating it in my opinion and fix it across the project both in
kclient fuse.


>
> > >
> > > > 3. I will fix up doutc in the next revision.
> > > > 4. The fs_name is part of the mdsmap in the server side [1]. The ke=
rnel client decodes only necessary fields from the mdsmap sent by the serve=
r. Until now, the fs_name
> > > >     was not being decoded, as part of this fix, it's required and b=
eing decoded.
> > > >
> > >
> > > Correct me if I am wrong. I can create a Ceph cluster with several MD=
S servers.
> > > In this cluster, I can create multiple file system volumes. And every=
 file
> > > system volume will have some name (fs_name). So, if we store fs_name =
into
> > > mdsmap, then which name do we imply here? Do we imply cluster name as=
 fs_name or
> > > name of particular file system volume?
> >
> > In CephFS, we mainly deal with two maps MDSMap[1] and FSMap[2]. The MDS=
Map represents
> > the state for a particular single filesystem. So the =E2=80=98fs_name=
=E2=80=99 in the MDSMap points to a file system
> > name that the MDSMap represents. Each filesystem will have a distinct M=
DSMap. The FSMap was
> > introduced to support multiple filesystems in the cluster. The FSMap ho=
lds all the filesystems in the
> > cluster using the MDSMap of each file system. The clients subscribe to =
these maps. So when kclient
> > is receiving a mdsmap, it=E2=80=99s corresponding to the filesystem it=
=E2=80=99s dealing with.
> >
>
> So, it's sounds to me that MDS keeps multiple MDSMaps for multiple file s=
ystems.
> And kernel side receives only MDSMap for operations. The FSMap is kept on=
 MDS
> side and kernel never receives it. Am I right here?

No, not really. The kclient decodes the FSMap as well. The fsname and
monitor ip are passed in the mount command, the kclient
contacts the monitor and receives the list of the file systems in the
cluster via FSMap. The passed fsname from the
mount command is compared against the list of file systems in the
FSMap decoded. If the fsname is found, it fetches
the fscid and requests the corresponding mdsmap from the respective
mds using fscid.

>
> Thanks,
> Slava.
>
> > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h
> > [2] https://github.com/ceph/ceph/blob/main/src/mds/FSMap.h
> >
> > Thanks,
> > Kotresh H R
> >
> > >
> > > Thanks,
> > > Slava.
> > >
> > > >
> > > >
> > >
> > > [1]
> > > https://elixir.bootlin.com/linux/v6.16/source/include/uapi/linux/limi=
ts.h#L12
> > >
> > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h#L596
> > > >
> > > > On Tue, Jul 29, 2025 at 11:57=E2=80=AFPM Viacheslav Dubeyko <Slava.=
Dubeyko@ibm.com> wrote:
> > > > > On Tue, 2025-07-29 at 22:32 +0530, khiremat@redhat.com wrote:
> > > > > > From: Kotresh HR <khiremat@redhat.com>
> > > > > >
> > > > > > The mds auth caps check should also validate the
> > > > > > fsname along with the associated caps. Not doing
> > > > > > so would result in applying the mds auth caps of
> > > > > > one fs on to the other fs in a multifs ceph cluster.
> > > > > > The patch fixes the same.
> > > > > >
> > > > > > Steps to Reproduce (on vstart cluster):
> > > > > > 1. Create two file systems in a cluster, say 'a' and 'b'
> > > > > > 2. ceph fs authorize a client.usr / r
> > > > > > 3. ceph fs authorize b client.usr / rw
> > > > > > 4. ceph auth get client.usr >> ./keyring
> > > > > > 5. sudo bin/mount.ceph usr@.a=3D/ /kmnt_a_usr/
> > > > > > 6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
> > > > > > 7. sudo bin/mount.ceph admin@.a=3D/ /kmnt_a_admin
> > > > > > 8. echo "data" > /kmnt_a_admin/admin_file1
> > > > > > 9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED)
> > > > > >
> > > > >
> > > > > I think we are missing to explain here which problem or
> > > > > symptoms will see the user that has this issue. I assume that
> > > > > this will be seen as the issue reproduction:
> > > > >
> > > > > With client_3 which has only 1 filesystem in caps is working as e=
xpected
> > > > > mkdir /mnt/client_3/test_3
> > > > > mkdir: cannot create directory =E2=80=98/mnt/client_3/test_3=E2=
=80=99: Permission denied
> > > > >
> > > > > Am I correct here?
> > > > >
> > > > > > URL: https://tracker.ceph.com/issues/72167
> > > > > > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > > > > > ---
> > > > > >   fs/ceph/mds_client.c | 10 ++++++++++
> > > > > >   fs/ceph/mdsmap.c     | 11 ++++++++++-
> > > > > >   fs/ceph/mdsmap.h     |  1 +
> > > > > >   3 files changed, 21 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > index 9eed6d73a508..ba91f3360ff6 100644
> > > > > > --- a/fs/ceph/mds_client.c
> > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(struct c=
eph_mds_client *mdsc,
> > > > > >        u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid)=
;
> > > > > >        u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid)=
;
> > > > > >        struct ceph_client *cl =3D mdsc->fsc->client;
> > > > > > +     const char *fs_name =3D mdsc->mdsmap->fs_name;
> > > > > >        const char *spath =3D mdsc->fsc->mount_options->server_p=
ath;
> > > > > >        bool gid_matched =3D false;
> > > > > >        u32 gid, tlen, len;
> > > > > >        int i, j;
> > > > > >
> > > > > > +     if (auth->match.fs_name && strcmp(auth->match.fs_name, fs=
_name)) {
> > > > >
> > > > > Should we consider to use strncmp() here?
> > > > > We should have the limitation of maximum possible name length.
> > > > >
> > > > > > +             doutc(cl, "fsname check failed fs_name=3D%s  matc=
h.fs_name=3D%s\n",
> > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > +             return 0;
> > > > > > +     } else {
> > > > > > +             doutc(cl, "fsname check passed fs_name=3D%s  matc=
h.fs_name=3D%s\n",
> > > > > > +                   fs_name, auth->match.fs_name);
> > > > >
> > > > > I assume that we could call the doutc with auth->match.fs_name =
=3D=3D NULL. So, I am
> > > > > expecting to have a crash here.
> > > > >
> > > > > > +     }
> > > > > > +
> > > > > >        doutc(cl, "match.uid %lld\n", auth->match.uid);
> > > > > >        if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> > > > > >                if (auth->match.uid !=3D caller_uid)
> > > > > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > > > > index 8109aba66e02..f1431ba0b33e 100644
> > > > > > --- a/fs/ceph/mdsmap.c
> > > > > > +++ b/fs/ceph/mdsmap.c
> > > > > > @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(str=
uct ceph_mds_client *mdsc, void **p,
> > > > > >                /* enabled */
> > > > > >                ceph_decode_8_safe(p, end, m->m_enabled, bad_ext=
);
> > > > > >                /* fs_name */
> > > > > > -             ceph_decode_skip_string(p, end, bad_ext);
> > > > > > +             m->fs_name =3D ceph_extract_encoded_string(p, end=
, NULL, GFP_NOFS);
> > > > > > +             if (IS_ERR(m->fs_name)) {
> > > > > > +                     err =3D PTR_ERR(m->fs_name);
> > > > > > +                     m->fs_name =3D NULL;
> > > > > > +                     if (err =3D=3D -ENOMEM)
> > > > > > +                             goto out_err;
> > > > > > +                     else
> > > > > > +                             goto bad;
> > > > > > +             }
> > > > > >        }
> > > > > >        /* damaged */
> > > > > >        if (mdsmap_ev >=3D 9) {
> > > > > > @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap=
 *m)
> > > > > >                kfree(m->m_info);
> > > > > >        }
> > > > > >        kfree(m->m_data_pg_pools);
> > > > > > +     kfree(m->fs_name);
> > > > > >        kfree(m);
> > > > > >   }
> > > > > >
> > > > > > diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> > > > > > index 1f2171dd01bf..acb0a2a3627a 100644
> > > > > > --- a/fs/ceph/mdsmap.h
> > > > > > +++ b/fs/ceph/mdsmap.h
> > > > > > @@ -45,6 +45,7 @@ struct ceph_mdsmap {
> > > > > >        bool m_enabled;
> > > > > >        bool m_damaged;
> > > > > >        int m_num_laggy;
> > > > > > +     char *fs_name;
> > > > >
> > > > > The ceph_mdsmap structure describes servers in the mds cluster [1=
].
> > > > > Semantically, I don't see any relation of fs_name with this struc=
ture.
> > > > > As a result, I don't see the point to keep this pointer in this s=
tructure.
> > > > > Why the fs_name has been placed in this structure?
> > > > >
> > > > > Thanks,
> > > > > Slava.
> > > > >
> > > > > >   };
> > > > > >
> > > > > >   static inline struct ceph_entity_addr *
> > > > >
> > > > > [1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/mdsmap.=
h#L11
> > > > >


