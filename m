Return-Path: <ceph-devel+bounces-3462-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D28BB2C68A
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Aug 2025 16:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6565F1B642C5
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Aug 2025 14:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A83A1FBEB1;
	Tue, 19 Aug 2025 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xs679odb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A510A20C47C
	for <ceph-devel@vger.kernel.org>; Tue, 19 Aug 2025 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755612092; cv=none; b=LVW8rKVCcJrw8PMoYIw60UndRpl1Qg8yGCbmV6qvHldEVIseaSmwMo5vvczEbqcwUkT536Z9Bh0AC5kmTTlAgiUWyhveIwbolLL5wxQhsjVHbFVOwWyLZwKfK902DVkzASwFjbfKkxHGSrPGRWVZ3JhpBM7VQA6Gzia6a1b2R2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755612092; c=relaxed/simple;
	bh=IdEHBZK0RL8F8rprdpPDJ+GIlt7XWWEazKTzg9N0bZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ATNyNKthWIyrahMsnS2Ag7ionw3uoKtXg5nL33t+9iPn8r/xD1czVaEHT/E8QcxNmpOmUvVJExJH+cc2FErfrogENsyM51nmcGPg+6srDUhQznTfO/xfXqIZwlDCPX82Dgx9gJ+XtZJWP+AM6fLM8aNac43vGec7DjviAK6f1EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xs679odb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755612089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+oijVGCD65HYphvAitOo1OvSSzlv64/j8Sty2TAZEis=;
	b=Xs679odb8VCh0s/7duDbScm1eWaNfsmKZM5GgRjwMcT+JlQlnzPBGhZZOmmySSztgF+aWG
	v5ypr3A9RH4PTPTjos12db4nYoqxNpDlX9DzQ01TjSgX7pEjeKL21ww6PYIisiz7H2+7IR
	0cTDDdbmInWzlvHbf0/TrP5HjkGxiD4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-Chz5GUinOVu9OIMi0tTgOQ-1; Tue, 19 Aug 2025 10:01:27 -0400
X-MC-Unique: Chz5GUinOVu9OIMi0tTgOQ-1
X-Mimecast-MFC-AGG-ID: Chz5GUinOVu9OIMi0tTgOQ_1755612087
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b4716fc56a9so8846439a12.0
        for <ceph-devel@vger.kernel.org>; Tue, 19 Aug 2025 07:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755612087; x=1756216887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+oijVGCD65HYphvAitOo1OvSSzlv64/j8Sty2TAZEis=;
        b=FZWJNEn3m8XU8aYmpt7KlGdRISCoyEw+w6mWZk0X9QLyJEfdQ1ateU4ma4rk8Zl2em
         kelaTvW9gSOdSi5RMNLKF6VNxG5bOmRSaMhG48Iv7KDfaa2w31tJ5IZIlblNXQcB/Cz2
         mFkAEAVhgSbWi8Y87B13hCfeq7Y23PCA9XPSQzSX8ZE8Qiw1QBMAcWfuZhPo48arNkgc
         3RqqfbPGDyRB1Mme9UtYJy2rsarh2rN0Zz6uAw/vAm4WVndply3nLDhEboVBXxy9LNgt
         l2xwB40oHGIfgZ1e8zJI5+Dk4GNdCuqZtDn7gl/btGtAycv/vyoR+DhsDHuwNuvlHaRE
         WxLg==
X-Gm-Message-State: AOJu0YyJxF6qE4SWLcNjxRUnEVuPQr/sF/Qixi73t3TQAZM0Cciy65W2
	zJ3vQipTANOgP4loXw2G+jY4QrwlpVgSRIPVvSIx40Zc2LSMAsv42MsVOyrUaP0RD6SB3+CTUyv
	7bYT0PdXX0wTR3GsFiRxr/Gv86zvQIaIEP0nZX2k9+fuHGVo5SCFfAvNuP9P6cZdPKLXeZTwciO
	XH2DPOcA2qh7P6HD6xc7u2zAMSZrnDwEt1P3Im
X-Gm-Gg: ASbGncvQmiPVGazRpul3Fae8Bfp4y8XahIGJJdygrw/vCFhn+12ukonIMdUB2Z3JXqm
	TB+/p1fqXfsEOYsBZYsw0NyGBaGj0vc8nWObWvpvwMHFmsUzL+5uba9p/YJQ5YiJfiO4KGlWQUJ
	OB9SUl5wpkbYhDiAv/
X-Received: by 2002:a05:6a20:7d9b:b0:240:af8:1758 with SMTP id adf61e73a8af0-2430d4d554emr3885506637.45.1755612084444;
        Tue, 19 Aug 2025 07:01:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6u2HBExSS4EwewOhJC/Mcu6EWoML3e/zEEp+Ed1Q6rD0HTcdAYqoCJGH6mgA92y6grnNn2iV0GVndfBDa+Ms=
X-Received: by 2002:a05:6a20:7d9b:b0:240:af8:1758 with SMTP id
 adf61e73a8af0-2430d4d554emr3885355637.45.1755612083341; Tue, 19 Aug 2025
 07:01:23 -0700 (PDT)
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
 <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com> <CAPgWtC5EVzdWZbF3NgntHaT03fiqH=NM-HTUPunE6GeJD1QPSw@mail.gmail.com>
 <ae92e8a5cf730e997d031adb5e1708f17975e8a9.camel@ibm.com>
In-Reply-To: <ae92e8a5cf730e997d031adb5e1708f17975e8a9.camel@ibm.com>
From: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Date: Tue, 19 Aug 2025 19:31:12 +0530
X-Gm-Features: Ac12FXy904tCIh13y9tSwApQSPxCP7UIIECbja1NrY8KPJVYRdnxDMPLK0bdblU
Message-ID: <CAPgWtC6QSaGfrjHWRiW9OL6SF4fpKedqXzb1mUzjhNepRh-C=A@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix multifs mds auth caps issue
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Venky Shankar <vshankar@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 11:52=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-08-13 at 12:58 +0530, Kotresh Hiremath Ravishankar wrote:
> > On Wed, Aug 13, 2025 at 1:22=E2=80=AFAM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Tue, 2025-08-12 at 14:37 +0530, Kotresh Hiremath Ravishankar wrote=
:
> > > > On Tue, Aug 12, 2025 at 2:50=E2=80=AFAM Viacheslav Dubeyko
> > > > <Slava.Dubeyko@ibm.com> wrote:
> > > > >
> > > > > On Wed, 2025-08-06 at 14:23 +0530, Kotresh Hiremath Ravishankar w=
rote:
> > > > > > On Sat, Aug 2, 2025 at 1:=E2=80=8A31 AM Viacheslav Dubeyko <Sla=
va.=E2=80=8ADubeyko@=E2=80=8Aibm.=E2=80=8Acom> wrote: > > On Fri, 2025-08-0=
1 at 22:=E2=80=8A59 +0530, Kotresh Hiremath Ravishankar wrote: > > > > Hi, =
> > > > 1. I will modify the commit message
> > > > > >
> > > > > > On Sat, Aug 2, 2025 at 1:31=E2=80=AFAM Viacheslav Dubeyko <Slav=
a.Dubeyko@ibm.com> wrote:
> > > > > > >
> > > > > > > On Fri, 2025-08-01 at 22:59 +0530, Kotresh Hiremath Ravishank=
ar wrote:
> > > > > > > >
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > 1. I will modify the commit message to clearly explain the =
issue in the next revision.
> > > > > > > > 2. The maximum possible length for the fsname is not define=
d in mds side. I didn't find any restriction imposed on the length. So we n=
eed to live with it.
> > > > > > >
> > > > > > > We have two constants in Linux kernel [1]:
> > > > > > >
> > > > > > > #define NAME_MAX         255    /* # chars in a file name */
> > > > > > > #define PATH_MAX        4096    /* # chars in a path name inc=
luding nul */
> > > > > > >
> > > > > > > I don't think that fsname can be bigger than PATH_MAX.
> > > > > >
> > > > > > As I had mentioned earlier, the CephFS server side code is not =
restricting the filesystem name
> > > > > > during creation. I validated the creation of a filesystem name =
with a length of 5000.
> > > > > > Please try the following.
> > > > > >
> > > > > > [kotresh@fedora build]$ alpha_str=3D$(< /dev/urandom tr -dc 'a-=
zA-Z' | head -c 5000)
> > > > > > [kotresh@fedora build]$ ceph fs new $alpha_str cephfs_data ceph=
fs_metadata
> > > > > > [kotresh@fedora build]$ bin/ceph fs ls
> > > > > >
> > > > > > So restricting the fsname length in the kclient would likely ca=
use issues. If we need to enforce the limitation, I think, it should be don=
e at server side first and it=E2=80=99s a separate effort.
> > > > > >
> > > > >
> > > > > I am not sure that Linux kernel is capable to digest any name big=
ger than
> > > > > NAME_MAX. Are you sure that we can pass xfstests with filesystem =
name bigger
> > > > > than NAME_MAX? Another point here that we can put buffer with nam=
e inline
> > > > > into struct ceph_mdsmap if the name cannot be bigger than NAME_MA=
X, for example.
> > > > > In this case we don't need to allocate fs_name memory for every
> > > > > ceph_mdsmap_decode() call.
> > > >
> > > > Well, I haven't tried xfstests with a filesystem name bigger than
> > > > NAME_MAX. But I did try mounting a ceph filesystem name bigger than
> > > > NAME_MAX and it works.
> > > > But mounting a ceph filesystem name bigger than PATH_MAX didn't wor=
k.
> > > > Note that the creation of a ceph filesystem name bigger than PATH_M=
AX
> > > > works and
> > > > mounting with the same using fuse client works as well.
> > > >
> > >
> > > The mount operation creates only root folder. So, probably, kernel ca=
n survive
> > > by creating root folder if filesystem name fits into PATH_MAX. Howeve=
r, if we
> > > will try to create another folders and files in the root folder, then=
 path
> > > becomes bigger and bigger. And I think that total path name length sh=
ould be
> > > lesser than PATH_MAX. So, I could say that it is much safer to assume=
 that
> > > filesystem name should fit into NAME_MAX.
> >
> > I didn't spend time root causing this issue. But logically, it makes
> > sense to fit the NAME_MAX to adhere to PATH_MAX.
> > But where does the filesystem name get used as a path component
> > internally so that it affects functionality ? I can think of
> > /etc/fstab and /proc/mounts, but can that affect functionality ?
> >
>
> Usually, file systems haven't file system name. :) The volume could be
> identified by UUID (128 bytes) that, usually, stored in the superblock. S=
o,
> CephFS could be slightly special if it adds file system name into path fo=
r file
> system operations.
>
> But I cannot imagine anyone that needs to create a Ceph filesystem with n=
ame
> bigger than NAME_MAX in length. :)
>
> I had hope that file system name is used by CephFS kernel client internal=
ly and
> never involved into path operations. If we have some issues here, then we=
 need
> to take a deeper look.
>
> > >
> > > > I was going through ceph kernel client code, historically, the
> > > > filesystem name is stored as a char pointer. The filesystem name fr=
om
> > > > mount options is stored
> > > > into 'struct ceph_mount_options' in 'ceph_parse_new_source' and the
> > > > same is used to compare against the fsmap received from the mds in
> > > > 'ceph_mdsc_handle_fsmap'
> > > >
> > > > struct ceph_mount_options {
> > > >     ...
> > > >     char *mds_namespace;  /* default NULL */
> > > >     ...
> > > > };
> > > >
> > >
> > > There is no historical traditions here. :) It is only question of eff=
iciency. If
> > > we know the limit of name, then it could be more efficient to have st=
atic name
> > > buffer embedded into the structure instead of dynamic memory allocati=
on.
> > > Because, we allocate memory for frequently accessed objects from kmem=
_cache or
> > > memory_pool. And allocating memory from SLUB allocator could be not o=
nly
> > > inefficient but the allocation request could fail if the system is un=
der memory
> > > pressure.
> >
> > Yes, absolutely correctness and efficiency is what matters. On the
> > correctness part,
> > there are multiple questions/points to be considered.
> >
> > 1. What happens to existing filesystems whose name length is greater
> > than NAME_MAX ?
>
> As I mentioned, usually, file systems haven't file system name.
>
> > 2. We should restrict creation of filesystem names greater than NAME_MA=
X length.
> > 3. We should also enforce the same on fuse clients.
> > 4. We should do it in all the places in the kernel code where the
> > fsname is stored and used.
> >
> > Thinking on the above lines, enforcing fs name length limitation
> > should be a separate
> > effort and is outside the scope of this patch is my opinion.
> >
> >
>
> I had two points from the beginning of the discussion: (1) consider to us=
e
> inline buffer for file system name, (2) struct ceph_mdsmap is not proper =
place
> for file system name.
>
> OK. I agree that restriction creation of filesystem names greater than NA=
ME_MAX
> length should be considered as independent task.
>

Are you suggesting to use the inline buffer for fsname with NAME_MAX
as the limit
with this patch ?

> So, if we are receiving filesystem name as mount command's option, then I=
 think
> we need to consider another structure(s) for fs_name and we can store it =
during
> mount phase. Potentially, we can consider struct ceph_fs_client [1], stru=
ct
> ceph_mount_options [2], or struct ceph_client [3]. But I think that struc=
t
> ceph_mount_options looks like a more proper place. What do you think?
>

We do this already. The fsname is saved in the 'struct ceph_mount_options' =
as we
parse it from the mount options. I think this is used only during the
mount. The
mds server does send mdsmap and fsname is part of it. This will be used for=
 mds
authcaps validation. Are you suggesting not to decode the fsname from mdsma=
p ?


> Thanks,
> Slava.
>
> [1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/super.h#L120
> [2] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph/super.h#L80
> [3]
> https://elixir.bootlin.com/linux/v6.16/source/include/linux/ceph/libceph.=
h#L115
>
> >
> > >
> > > > I am not sure what's the right approach to choose here. In kclient,
> > > > assuming ceph fsname not to be bigger than PATH_MAX seems to be saf=
e
> > > > as the kclient today is
> > > > not able to mount the ceph fsname bigger than PATH_MAX. I also
> > > > observed that the kclient failed to mount the ceph fsname with leng=
th
> > > > little less than
> > > > PATH_MAX (4090). So it's breaking somewhere with the entire path
> > > > component being considered. Anyway, I will open the discussion to
> > > > everyone here.
> > > > If we are restricting the max fsname length, we need to restrict it
> > > > while creating it in my opinion and fix it across the project both =
in
> > > > kclient fuse.
> > > >
> > > >
> > >
> > > I could say that it is much safer to assume that filesystem name shou=
ld fit into
> > > NAME_MAX.
> > >
> > >
> > > Thanks,
> > > Slava.
> > >
> > > > >
> > > > > > >
> > > > > > > > 3. I will fix up doutc in the next revision.
> > > > > > > > 4. The fs_name is part of the mdsmap in the server side [1]=
. The kernel client decodes only necessary fields from the mdsmap sent by t=
he server. Until now, the fs_name
> > > > > > > >     was not being decoded, as part of this fix, it's requir=
ed and being decoded.
> > > > > > > >
> > > > > > >
> > > > > > > Correct me if I am wrong. I can create a Ceph cluster with se=
veral MDS servers.
> > > > > > > In this cluster, I can create multiple file system volumes. A=
nd every file
> > > > > > > system volume will have some name (fs_name). So, if we store =
fs_name into
> > > > > > > mdsmap, then which name do we imply here? Do we imply cluster=
 name as fs_name or
> > > > > > > name of particular file system volume?
> > > > > >
> > > > > > In CephFS, we mainly deal with two maps MDSMap[1] and FSMap[2].=
 The MDSMap represents
> > > > > > the state for a particular single filesystem. So the =E2=80=98f=
s_name=E2=80=99 in the MDSMap points to a file system
> > > > > > name that the MDSMap represents. Each filesystem will have a di=
stinct MDSMap. The FSMap was
> > > > > > introduced to support multiple filesystems in the cluster. The =
FSMap holds all the filesystems in the
> > > > > > cluster using the MDSMap of each file system. The clients subsc=
ribe to these maps. So when kclient
> > > > > > is receiving a mdsmap, it=E2=80=99s corresponding to the filesy=
stem it=E2=80=99s dealing with.
> > > > > >
> > > > >
> > > > > So, it's sounds to me that MDS keeps multiple MDSMaps for multipl=
e file systems.
> > > > > And kernel side receives only MDSMap for operations. The FSMap is=
 kept on MDS
> > > > > side and kernel never receives it. Am I right here?
> > > >
> > > > No, not really. The kclient decodes the FSMap as well. The fsname a=
nd
> > > > monitor ip are passed in the mount command, the kclient
> > > > contacts the monitor and receives the list of the file systems in t=
he
> > > > cluster via FSMap. The passed fsname from the
> > > > mount command is compared against the list of file systems in the
> > > > FSMap decoded. If the fsname is found, it fetches
> > > > the fscid and requests the corresponding mdsmap from the respective
> > > > mds using fscid.
> > > >
> > > > >
> > > > > Thanks,
> > > > > Slava.
> > > > >
> > > > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h
> > > > > > [2] https://github.com/ceph/ceph/blob/main/src/mds/FSMap.h
> > > > > >
> > > > > > Thanks,
> > > > > > Kotresh H R
> > > > > >
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Slava.
> > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > > [1]
> > > > > > > https://elixir.bootlin.com/linux/v6.16/source/include/uapi/li=
nux/limits.h#L12
> > > > > > >
> > > > > > > > [1] https://github.com/ceph/ceph/blob/main/src/mds/MDSMap.h=
#L596
> > > > > > > >
> > > > > > > > On Tue, Jul 29, 2025 at 11:57=E2=80=AFPM Viacheslav Dubeyko=
 <Slava.Dubeyko@ibm.com> wrote:
> > > > > > > > > On Tue, 2025-07-29 at 22:32 +0530, khiremat@redhat.com wr=
ote:
> > > > > > > > > > From: Kotresh HR <khiremat@redhat.com>
> > > > > > > > > >
> > > > > > > > > > The mds auth caps check should also validate the
> > > > > > > > > > fsname along with the associated caps. Not doing
> > > > > > > > > > so would result in applying the mds auth caps of
> > > > > > > > > > one fs on to the other fs in a multifs ceph cluster.
> > > > > > > > > > The patch fixes the same.
> > > > > > > > > >
> > > > > > > > > > Steps to Reproduce (on vstart cluster):
> > > > > > > > > > 1. Create two file systems in a cluster, say 'a' and 'b=
'
> > > > > > > > > > 2. ceph fs authorize a client.usr / r
> > > > > > > > > > 3. ceph fs authorize b client.usr / rw
> > > > > > > > > > 4. ceph auth get client.usr >> ./keyring
> > > > > > > > > > 5. sudo bin/mount.ceph usr@.a=3D/ /kmnt_a_usr/
> > > > > > > > > > 6. touch /kmnt_a_usr/file1 (SHOULD NOT BE ALLOWED)
> > > > > > > > > > 7. sudo bin/mount.ceph admin@.a=3D/ /kmnt_a_admin
> > > > > > > > > > 8. echo "data" > /kmnt_a_admin/admin_file1
> > > > > > > > > > 9. rm -f /kmnt_a_usr/admin_file1 (SHOULD NOT BE ALLOWED=
)
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > I think we are missing to explain here which problem or
> > > > > > > > > symptoms will see the user that has this issue. I assume =
that
> > > > > > > > > this will be seen as the issue reproduction:
> > > > > > > > >
> > > > > > > > > With client_3 which has only 1 filesystem in caps is work=
ing as expected
> > > > > > > > > mkdir /mnt/client_3/test_3
> > > > > > > > > mkdir: cannot create directory =E2=80=98/mnt/client_3/tes=
t_3=E2=80=99: Permission denied
> > > > > > > > >
> > > > > > > > > Am I correct here?
> > > > > > > > >
> > > > > > > > > > URL: https://tracker.ceph.com/issues/72167
> > > > > > > > > > Signed-off-by: Kotresh HR <khiremat@redhat.com>
> > > > > > > > > > ---
> > > > > > > > > >   fs/ceph/mds_client.c | 10 ++++++++++
> > > > > > > > > >   fs/ceph/mdsmap.c     | 11 ++++++++++-
> > > > > > > > > >   fs/ceph/mdsmap.h     |  1 +
> > > > > > > > > >   3 files changed, 21 insertions(+), 1 deletion(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.=
c
> > > > > > > > > > index 9eed6d73a508..ba91f3360ff6 100644
> > > > > > > > > > --- a/fs/ceph/mds_client.c
> > > > > > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > > > > > @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(=
struct ceph_mds_client *mdsc,
> > > > > > > > > >        u32 caller_uid =3D from_kuid(&init_user_ns, cred=
->fsuid);
> > > > > > > > > >        u32 caller_gid =3D from_kgid(&init_user_ns, cred=
->fsgid);
> > > > > > > > > >        struct ceph_client *cl =3D mdsc->fsc->client;
> > > > > > > > > > +     const char *fs_name =3D mdsc->mdsmap->fs_name;
> > > > > > > > > >        const char *spath =3D mdsc->fsc->mount_options->=
server_path;
> > > > > > > > > >        bool gid_matched =3D false;
> > > > > > > > > >        u32 gid, tlen, len;
> > > > > > > > > >        int i, j;
> > > > > > > > > >
> > > > > > > > > > +     if (auth->match.fs_name && strcmp(auth->match.fs_=
name, fs_name)) {
> > > > > > > > >
> > > > > > > > > Should we consider to use strncmp() here?
> > > > > > > > > We should have the limitation of maximum possible name le=
ngth.
> > > > > > > > >
> > > > > > > > > > +             doutc(cl, "fsname check failed fs_name=3D=
%s  match.fs_name=3D%s\n",
> > > > > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > > > > > +             return 0;
> > > > > > > > > > +     } else {
> > > > > > > > > > +             doutc(cl, "fsname check passed fs_name=3D=
%s  match.fs_name=3D%s\n",
> > > > > > > > > > +                   fs_name, auth->match.fs_name);
> > > > > > > > >
> > > > > > > > > I assume that we could call the doutc with auth->match.fs=
_name =3D=3D NULL. So, I am
> > > > > > > > > expecting to have a crash here.
> > > > > > > > >
> > > > > > > > > > +     }
> > > > > > > > > > +
> > > > > > > > > >        doutc(cl, "match.uid %lld\n", auth->match.uid);
> > > > > > > > > >        if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
> > > > > > > > > >                if (auth->match.uid !=3D caller_uid)
> > > > > > > > > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > > > > > > > > index 8109aba66e02..f1431ba0b33e 100644
> > > > > > > > > > --- a/fs/ceph/mdsmap.c
> > > > > > > > > > +++ b/fs/ceph/mdsmap.c
> > > > > > > > > > @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_de=
code(struct ceph_mds_client *mdsc, void **p,
> > > > > > > > > >                /* enabled */
> > > > > > > > > >                ceph_decode_8_safe(p, end, m->m_enabled,=
 bad_ext);
> > > > > > > > > >                /* fs_name */
> > > > > > > > > > -             ceph_decode_skip_string(p, end, bad_ext);
> > > > > > > > > > +             m->fs_name =3D ceph_extract_encoded_strin=
g(p, end, NULL, GFP_NOFS);
> > > > > > > > > > +             if (IS_ERR(m->fs_name)) {
> > > > > > > > > > +                     err =3D PTR_ERR(m->fs_name);
> > > > > > > > > > +                     m->fs_name =3D NULL;
> > > > > > > > > > +                     if (err =3D=3D -ENOMEM)
> > > > > > > > > > +                             goto out_err;
> > > > > > > > > > +                     else
> > > > > > > > > > +                             goto bad;
> > > > > > > > > > +             }
> > > > > > > > > >        }
> > > > > > > > > >        /* damaged */
> > > > > > > > > >        if (mdsmap_ev >=3D 9) {
> > > > > > > > > > @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct cep=
h_mdsmap *m)
> > > > > > > > > >                kfree(m->m_info);
> > > > > > > > > >        }
> > > > > > > > > >        kfree(m->m_data_pg_pools);
> > > > > > > > > > +     kfree(m->fs_name);
> > > > > > > > > >        kfree(m);
> > > > > > > > > >   }
> > > > > > > > > >
> > > > > > > > > > diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> > > > > > > > > > index 1f2171dd01bf..acb0a2a3627a 100644
> > > > > > > > > > --- a/fs/ceph/mdsmap.h
> > > > > > > > > > +++ b/fs/ceph/mdsmap.h
> > > > > > > > > > @@ -45,6 +45,7 @@ struct ceph_mdsmap {
> > > > > > > > > >        bool m_enabled;
> > > > > > > > > >        bool m_damaged;
> > > > > > > > > >        int m_num_laggy;
> > > > > > > > > > +     char *fs_name;
> > > > > > > > >
> > > > > > > > > The ceph_mdsmap structure describes servers in the mds cl=
uster [1].
> > > > > > > > > Semantically, I don't see any relation of fs_name with th=
is structure.
> > > > > > > > > As a result, I don't see the point to keep this pointer i=
n this structure.
> > > > > > > > > Why the fs_name has been placed in this structure?
> > > > > > > > >
> > > > > > > > > Thanks,
> > > > > > > > > Slava.
> > > > > > > > >
> > > > > > > > > >   };
> > > > > > > > > >
> > > > > > > > > >   static inline struct ceph_entity_addr *
> > > > > > > > >
> > > > > > > > > [1] https://elixir.bootlin.com/linux/v6.16/source/fs/ceph=
/mdsmap.h#L11
> > > > > > > > >
> > >
>


