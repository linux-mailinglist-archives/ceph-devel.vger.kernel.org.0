Return-Path: <ceph-devel+bounces-3437-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6814B242B5
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Aug 2025 09:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AECC87BAD25
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Aug 2025 07:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D43B2D3209;
	Wed, 13 Aug 2025 07:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hIey/Pqb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B62DAFB1
	for <ceph-devel@vger.kernel.org>; Wed, 13 Aug 2025 07:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755070128; cv=none; b=BNwvTVZBHHDxC2ZxSAJB09Z6pFSImQqwBH8/wnFp9CUYhYByJ7Ojn/KumjEPq9cf+CUTQPUGv9j/7o7VidJr2sgkYpWX7EYWW6qu28vDdRW8j4ghd5Nv1sgli0QpwDKzxVP/LJasQqztSuwH07iAiJPToeAb/Vg/CH8sVK/pteI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755070128; c=relaxed/simple;
	bh=LdS4uyNM1qznT6RFjLHDvCRZf+2/+IDTNqSHneCeav0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=Fk1MWgzEcG44GLIpNceO6oJd33rqr8kK8mUTFUUk/n1MPaHTtE/QqxOu0jh7kvCHMJOTWeXsF4uWCvBn9p5fOQW+D0GAHuDaAdpWARrlrfLNI0bgFw62BaPcgr0LuDWOeW4CJ27WTN+7O80qaUA6TX7KJ47PmEj5s+wEE5ZJSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hIey/Pqb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755070124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6RR0nADgokkkHbu1xEGDKmVwqxonLHxC0qQLcT1qV84=;
	b=hIey/Pqbbc9KlJWSzYDJ+w4jIOEjFrBzmM9Clrks3LROrSdZudGQTI5co19z2Pq3raufpG
	xIcITVoGmixxG12a1oeBapKiNKun9rWZ5INnX1jezBc83SYmpVXd4rhak0wABEtYK8n9vW
	NUmHQB2c6/9w/5xwANDLgd6BiLBsSgQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280--MCjyHlAOvC_Qd_gg0eThA-1; Wed, 13 Aug 2025 03:28:43 -0400
X-MC-Unique: -MCjyHlAOvC_Qd_gg0eThA-1
X-Mimecast-MFC-AGG-ID: -MCjyHlAOvC_Qd_gg0eThA_1755070122
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-31f729bf733so10898462a91.1
        for <ceph-devel@vger.kernel.org>; Wed, 13 Aug 2025 00:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755070122; x=1755674922;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6RR0nADgokkkHbu1xEGDKmVwqxonLHxC0qQLcT1qV84=;
        b=OuFNasDHpDoWk6Lt1wUeGui0C5L5endqmDRawIUMDgdbdHI0KzbsVSU7oMsHBdNtEY
         U20SS4NQPDt6/u6ArCenflj3i6PTRD2JEsOzSlORFcS9+yJunipDV9xWl8MKaBXeVdIg
         UbHV/kxHUrwhOvRrqN2ZnVjNF97dMrXKxPNuECrGmGDvPNNuxmbCHgUCV1+pQMPOMcS2
         G2luWxY96/GwmmzHBILWdFa5Zs0uQ+/BYw42eJCfb2DycOwlC3qJHMNu0X0z1b/XlVGN
         HtmRZMBCOuUCSAlorKUyAbctXyICDo3lZ4w2URLEBT809Nd98JH6yrDfKVZEMd1oq3bj
         2jtA==
X-Forwarded-Encrypted: i=1; AJvYcCU1b0cG2WNIwZNFkXuDkP8pxOZcKyS4nfSjn2H3O14NVibxfziOnP1z/oeyp1Gg/bTDSfJLBTvD0hih@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn14cdufiFRU9YUXtUp3l5BXaEHn+/zI9Kj69c73oKqjKASDCy
	gpHwGqB3dEZIOF6F6GE4eDVMWykWMlG7nDbHswa/SvlF2q9iv0/y4T9bym1uKKxFc5c7hzRqnL1
	alVbt5MOQU4DHWWzICF9dsBT2EIte9GeqWCOfYfTkZifXXuCEeZ9simZvZntRCLff7MgYng++8p
	c1QG/Wr466I8DYcKNu+6y6h2URoN3VWvy75zhxZkmhtEAP
X-Gm-Gg: ASbGncsaX6sj6NixVfvDIUSV3lqweKkvOFueoPWr+TTIXNsBvTupjBUWh1vRm4f1L8/
	Rm+Mx0mSx6oHWpHQNGm/cBK5TX1Ekc0A0w/NEm0Th1cljUKcjIIL4lYADCN+zgNcnhs4KlucKKD
	VE5TMLqla7g4z4A6J5
X-Google-Smtp-Source: AGHT+IGoJZYXsJYPK5MXgZZk+9nAPlOuel6Fapq794erhMMs/fqCOxrpsQOTc19DnLOud2FEDRQz182XLWwTphtouhY=
X-Received: by 2002:a17:90b:3fcc:b0:31f:2ef4:bc04 with SMTP id 98e67ed59e1d1-321d0db3fe8mr2952202a91.14.1755070121461;
        Wed, 13 Aug 2025 00:28:41 -0700 (PDT)
X-Received: by 2002:a17:90b:3fcc:b0:31f:2ef4:bc04 with SMTP id
 98e67ed59e1d1-321d0db3fe8mt2949531a91.14.1755070120820; Wed, 13 Aug 2025
 00:28:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729170240.118794-1-khiremat@redhat.com> <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com> <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
 <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com> <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
 <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com>
In-Reply-To: <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com>
From: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date: Wed, 13 Aug 2025 12:58:28 +0530
X-Gm-Features: Ac12FXyc2YbgH1WfKp4BbmsvVG253d-B6RYft-MYnTtWNFI3vkXAoKZjxmBW7Z8
Message-ID: <CAPgWtC5EVzdWZbF3NgntHaT03fiqH=NM-HTUPunE6GeJD1QPSw@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix multifs mds auth caps issue
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Venky Shankar <vshankar@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Gregory Farnum <gfarnum@redhat.com>, 
	Viacheslav Dubeyko <slava.dubeyko@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 1:22=E2=80=AFAM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Tue, 2025-08-12 at 14:37 +0530, Kotresh Hiremath Ravishankar wrote:
> > On Tue, Aug 12, 2025 at 2:50=E2=80=AFAM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Wed, 2025-08-06 at 14:23 +0530, Kotresh Hiremath Ravishankar wrote=
:
> > > > On Sat, Aug 2, 2025 at 1:=E2=80=8A31 AM Viacheslav Dubeyko <Slava.=
=E2=80=8ADubeyko@=E2=80=8Aibm.=E2=80=8Acom> wrote: > > On Fri, 2025-08-01 a=
t 22:=E2=80=8A59 +0530, Kotresh Hiremath Ravishankar wrote: > > > > Hi, > >=
 > > 1. I will modify the commit message
> > > >
> > > > On Sat, Aug 2, 2025 at 1:31=E2=80=AFAM Viacheslav Dubeyko <Slava.Du=
beyko@ibm.com> wrote:
> > > > >
> > > > > On Fri, 2025-08-01 at 22:59 +0530, Kotresh Hiremath Ravishankar w=
rote:
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > 1. I will modify the commit message to clearly explain the issu=
e in the next revision.
> > > > > > 2. The maximum possible length for the fsname is not defined in=
 mds side. I didn't find any restriction imposed on the length. So we need =
to live with it.
> > > > >
> > > > > We have two constants in Linux kernel [1]:
> > > > >
> > > > > #define NAME_MAX         255    /* # chars in a file name */
> > > > > #define PATH_MAX        4096    /* # chars in a path name includi=
ng nul */
> > > > >
> > > > > I don't think that fsname can be bigger than PATH_MAX.
> > > >
> > > > As I had mentioned earlier, the CephFS server side code is not rest=
ricting the filesystem name
> > > > during creation. I validated the creation of a filesystem name with=
 a length of 5000.
> > > > Please try the following.
> > > >
> > > > [kotresh@fedora build]$ alpha_str=3D$(< /dev/urandom tr -dc 'a-zA-Z=
' | head -c 5000)
> > > > [kotresh@fedora build]$ ceph fs new $alpha_str cephfs_data cephfs_m=
etadata
> > > > [kotresh@fedora build]$ bin/ceph fs ls
> > > >
> > > > So restricting the fsname length in the kclient would likely cause =
issues. If we need to enforce the limitation, I think, it should be done at=
 server side first and it=E2=80=99s a separate effort.
> > > >
> > >
> > > I am not sure that Linux kernel is capable to digest any name bigger =
than
> > > NAME_MAX. Are you sure that we can pass xfstests with filesystem name=
 bigger
> > > than NAME_MAX? Another point here that we can put buffer with name in=
line
> > > into struct ceph_mdsmap if the name cannot be bigger than NAME_MAX, f=
or example.
> > > In this case we don't need to allocate fs_name memory for every
> > > ceph_mdsmap_decode() call.
> >
> > Well, I haven't tried xfstests with a filesystem name bigger than
> > NAME_MAX. But I did try mounting a ceph filesystem name bigger than
> > NAME_MAX and it works.
> > But mounting a ceph filesystem name bigger than PATH_MAX didn't work.
> > Note that the creation of a ceph filesystem name bigger than PATH_MAX
> > works and
> > mounting with the same using fuse client works as well.
> >
>
> The mount operation creates only root folder. So, probably, kernel can su=
rvive
> by creating root folder if filesystem name fits into PATH_MAX. However, i=
f we
> will try to create another folders and files in the root folder, then pat=
h
> becomes bigger and bigger. And I think that total path name length should=
 be
> lesser than PATH_MAX. So, I could say that it is much safer to assume tha=
t
> filesystem name should fit into NAME_MAX.

I didn't spend time root causing this issue. But logically, it makes
sense to fit the NAME_MAX to adhere to PATH_MAX.
But where does the filesystem name get used as a path component
internally so that it affects functionality ? I can think of
/etc/fstab and /proc/mounts, but can that affect functionality ?

>
> > I was going through ceph kernel client code, historically, the
> > filesystem name is stored as a char pointer. The filesystem name from
> > mount options is stored
> > into 'struct ceph_mount_options' in 'ceph_parse_new_source' and the
> > same is used to compare against the fsmap received from the mds in
> > 'ceph_mdsc_handle_fsmap'
> >
> > struct ceph_mount_options {
> >     ...
> >     char *mds_namespace;  /* default NULL */
> >     ...
> > };
> >
>
> There is no historical traditions here. :) It is only question of efficie=
ncy. If
> we know the limit of name, then it could be more efficient to have static=
 name
> buffer embedded into the structure instead of dynamic memory allocation.
> Because, we allocate memory for frequently accessed objects from kmem_cac=
he or
> memory_pool. And allocating memory from SLUB allocator could be not only
> inefficient but the allocation request could fail if the system is under =
memory
> pressure.

Yes, absolutely correctness and efficiency is what matters. On the
correctness part,
there are multiple questions/points to be considered.

1. What happens to existing filesystems whose name length is greater
than NAME_MAX ?
2. We should restrict creation of filesystem names greater than NAME_MAX le=
ngth.
3. We should also enforce the same on fuse clients.
4. We should do it in all the places in the kernel code where the
fsname is stored and used.

Thinking on the above lines, enforcing fs name length limitation
should be a separate
effort and is outside the scope of this patch is my opinion.

Thanks,
Kotresh H R

>
> > I am not sure what's the right approach to choose here. In kclient,
> > assuming ceph fsname not to be bigger than PATH_MAX seems to be safe
> > as the kclient today is
> > not able to mount the ceph fsname bigger than PATH_MAX. I also
> > observed that the kclient failed to mount the ceph fsname with length
> > little less than
> > PATH_MAX (4090). So it's breaking somewhere with the entire path
> > component being considered. Anyway, I will open the discussion to
> > everyone here.
> > If we are restricting the max fsname length, we need to restrict it
> > while creating it in my opinion and fix it across the project both in
> > kclient fuse.
> >
> >
>
> I could say that it is much safer to assume that filesystem name should f=
it into
> NAME_MAX.
>
>
> Thanks,
> Slava.
>
> > >
> > > > >
> > > > > > 3. I will fix up doutc in the next revision.
> > > > > > 4. The fs_name is part of the mdsmap in the server side [1]. Th=
e kernel client decodes only necessary fields from the mdsmap sent by the s=
erver. Until now, the fs_name
> > > > > >     was not being decoded, as part of this fix, it's required a=
nd being decoded.
> > > > > >
> > > > >
> > > > > Correct me if I am wrong. I can create a Ceph cluster with severa=
l MDS servers.
> > > > > In this cluster, I can create multiple file system volumes. And e=
very file
> > > > > system volume will have some name (fs_name). So, if we store fs_n=
ame into
> > > > > mdsmap, then which name do we imply here? Do we imply cluster nam=
e as fs_name or
> > > > > name of particular file system volume?
> > > >
> > > > In CephFS, we mainly deal with two maps MDSMap[1] and FSMap[2]. The=
 MDSMap represents
> > > > the state for a particular single filesystem. So the =E2=80=98fs_na=
me=E2=80=99 in the MDSMap points to a file system
> > > > name that the MDSMap represents. Each filesystem will have a distin=
ct MDSMap. The FSMap was
> > > > introduced to support multiple filesystems in the cluster. The FSMa=
p holds all the filesystems in the
> > > > cluster using the MDSMap of each file system. The clients subscribe=
 to these maps. So when kclient
> > > > is receiving a mdsmap, it=E2=80=99s corresponding to the filesystem=
 it=E2=80=99s dealing with.
> > > >
> > >
> > > So, it's sounds to me that MDS keeps multiple MDSMaps for multiple fi=
le systems.
> > > And kernel side receives only MDSMap for operations. The FSMap is kep=
t on MDS
> > > side and kernel never receives it. Am I right here?
> >
> > No, not really. The kclient decodes the FSMap as well. The fsname and
> > monitor ip are passed in the mount command, the kclient
> > contacts the monitor and receives the list of the file systems in the
> > cluster via FSMap. The passed fsname from the
> > mount command is compared against the list of file systems in the
> > FSMap decoded. If the fsname is found, it fetches
> > the fscid and requests the corresponding mdsmap from the respective
> > mds using fscid.
> >
> > >
> > > Thanks,
> > > Slava.
> > >
> > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h
> > > > [2] https://github.com/ceph/ceph/blob/main/src/mds/FSMap.h
> > > >
> > > > Thanks,
> > > > Kotresh H R
> > > >
> > > > >
> > > > > Thanks,
> > > > > Slava.
> > > > >
> > > > > >
> > > > > >
> > > > >
> > > > > [1]
> > > > > https://elixir.bootlin.com/linux/v6.16/source/include/uapi/linux/=
limits.h#L12
> > > > >
> > > > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h#L59=
6
> > > > > >
> > > > > > On Tue, Jul 29, 2025 at 11:57=E2=80=AFPM Viacheslav Dubeyko <Sl=
ava.Dubeyko@ibm.com> wrote:
> > > > > > > On Tue, 2025-07-29 at 22:32 +0530, khiremat@redhat.com wrote:
> > > > > > > > From: Kotresh HR <khiremat@redhat.com>
> > > > > > > >
> > > > > > > > The mds auth caps check should also validate the
> > > > > > > > fsname along with the associated caps. Not doing
> > > > > > > > so would result in applying the mds auth caps of
> > > > > > > > one fs on to the other fs in a multifs ceph cluster.
> > > > > > > > The patch fixes the same.
> > > > > > > >
> > > > > > > > Steps to Reproduce (on vstart cluster):
> > > > > > > > 1. Create two file systems in a cluster, say 'a' and 'b'
> > > > > > > > 2. ceph fs authorize a client.usr / r
> > > > > > > > 3. ceph fs authorize b client.usr / rw
> > > > > > > > 4. ceph auth get client.usr >> ./keyring
> > > > > > > > 5. sudo bin/mount.ceph usr@.a=3D/ /kmnt_a_usr/
> > > > > > > > 6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
> > > > > > > > 7. sudo bin/mount.ceph admin@.a=3D/ /kmnt_a_admin
> > > > > > > > 8. echo "data" > /kmnt_a_admin/admin_file1
> > > > > > > > 9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED)
> > > > > > > >
> > > > > > >
> > > > > > > I think we are missing to explain here which problem or
> > > > > > > symptoms will see the user that has this issue. I assume that
> > > > > > > this will be seen as the issue reproduction:
> > > > > > >
> > > > > > > With client_3 which has only 1 filesystem in caps is working =
as expected
> > > > > > > mkdir /mnt/client_3/test_3
> > > > > > > mkdir: cannot create directory =E2=80=98/mnt/client_3/test_3=
=E2=80=99: Permission denied
> > > > > > >
> > > > > > > Am I correct here?
> > > > > > >
> > > > > > > > URL: https://tracker.ceph.com/issues/72167
> > > > > > > > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > > > > > > > ---
> > > > > > > >   fs/ceph/mds_client.c | 10 ++++++++++
> > > > > > > >   fs/ceph/mdsmap.c     | 11 ++++++++++-
> > > > > > > >   fs/ceph/mdsmap.h     |  1 +
> > > > > > > >   3 files changed, 21 insertions(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > > > index 9eed6d73a508..ba91f3360ff6 100644
> > > > > > > > --- a/fs/ceph/mds_client.c
> > > > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > > > @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(stru=
ct ceph_mds_client *mdsc,
> > > > > > > >        u32 caller_uid =3D from_kuid(&init_user_ns, cred->fs=
uid);
> > > > > > > >        u32 caller_gid =3D from_kgid(&init_user_ns, cred->fs=
gid);
> > > > > > > >        struct ceph_client *cl =3D mdsc->fsc->client;
> > > > > > > > +     const char *fs_name =3D mdsc->mdsmap->fs_name;
> > > > > > > >        const char *spath =3D mdsc->fsc->mount_options->serv=
er_path;
> > > > > > > >        bool gid_matched =3D false;
> > > > > > > >        u32 gid, tlen, len;
> > > > > > > >        int i, j;
> > > > > > > >
> > > > > > > > +     if (auth->match.fs_name && strcmp(auth->match.fs_name=
, fs_name)) {
> > > > > > >
> > > > > > > Should we consider to use strncmp() here?
> > > > > > > We should have the limitation of maximum possible name length=
.
> > > > > > >
> > > > > > > > +             doutc(cl, "fsname check failed fs_name=3D%s  =
match.fs_name=3D%s\n",
> > > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > > > +             return 0;
> > > > > > > > +     } else {
> > > > > > > > +             doutc(cl, "fsname check passed fs_name=3D%s  =
match.fs_name=3D%s\n",
> > > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > >
> > > > > > > I assume that we could call the doutc with auth->match.fs_nam=
e =3D=3D NULL. So, I am
> > > > > > > expecting to have a crash here.
> > > > > > >
> > > > > > > > +     }
> > > > > > > > +
> > > > > > > >        doutc(cl, "match.uid %lld\n", auth->match.uid);
> > > > > > > >        if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> > > > > > > >                if (auth->match.uid !=3D caller_uid)
> > > > > > > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > > > > > > index 8109aba66e02..f1431ba0b33e 100644
> > > > > > > > --- a/fs/ceph/mdsmap.c
> > > > > > > > +++ b/fs/ceph/mdsmap.c
> > > > > > > > @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode=
(struct ceph_mds_client *mdsc, void **p,
> > > > > > > >                /* enabled */
> > > > > > > >                ceph_decode_8_safe(p, end, m->m_enabled, bad=
_ext);
> > > > > > > >                /* fs_name */
> > > > > > > > -             ceph_decode_skip_string(p, end, bad_ext);
> > > > > > > > +             m->fs_name =3D ceph_extract_encoded_string(p,=
 end, NULL, GFP_NOFS);
> > > > > > > > +             if (IS_ERR(m->fs_name)) {
> > > > > > > > +                     err =3D PTR_ERR(m->fs_name);
> > > > > > > > +                     m->fs_name =3D NULL;
> > > > > > > > +                     if (err =3D=3D -ENOMEM)
> > > > > > > > +                             goto out_err;
> > > > > > > > +                     else
> > > > > > > > +                             goto bad;
> > > > > > > > +             }
> > > > > > > >        }
> > > > > > > >        /* damaged */
> > > > > > > >        if (mdsmap_ev >=3D 9) {
> > > > > > > > @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_md=
smap *m)
> > > > > > > >                kfree(m->m_info);
> > > > > > > >        }
> > > > > > > >        kfree(m->m_data_pg_pools);
> > > > > > > > +     kfree(m->fs_name);
> > > > > > > >        kfree(m);
> > > > > > > >   }
> > > > > > > >
> > > > > > > > diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> > > > > > > > index 1f2171dd01bf..acb0a2a3627a 100644
> > > > > > > > --- a/fs/ceph/mdsmap.h
> > > > > > > > +++ b/fs/ceph/mdsmap.h
> > > > > > > > @@ -45,6 +45,7 @@ struct ceph_mdsmap {
> > > > > > > >        bool m_enabled;
> > > > > > > >        bool m_damaged;
> > > > > > > >        int m_num_laggy;
> > > > > > > > +     char *fs_name;
> > > > > > >
> > > > > > > The ceph_mdsmap structure describes servers in the mds cluste=
r [1].
> > > > > > > Semantically, I don't see any relation of fs_name with this s=
tructure.
> > > > > > > As a result, I don't see the point to keep this pointer in th=
is structure.
> > > > > > > Why the fs_name has been placed in this structure?
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Slava.
> > > > > > >
> > > > > > > >   };
> > > > > > > >
> > > > > > > >   static inline struct ceph_entity_addr *
> > > > > > >
> > > > > > > [1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/mds=
map.h#L11
> > > > > > >
>


