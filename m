Return-Path: <ceph-devel+bounces-4448-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEE5D29634
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jan 2026 01:13:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 16723300EE51
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jan 2026 00:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0882023ABB0;
	Fri, 16 Jan 2026 00:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMArgDoA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3772D79CD
	for <ceph-devel@vger.kernel.org>; Fri, 16 Jan 2026 00:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768522412; cv=none; b=BqmwAeotHFR/V3slC8V9NibvktkftThLiX/iv7Mtk7bIO8uOfzF+LPmPwOcRbKSAa4Twf8KEbtAv868VRvp0/ETNz5ZsHBiq0c1tsunWiDlSVa6e1VaYsKnO8s770dsUEHog3cq7RCOgA+okIHucm3lODaucPwrs0wMJCRwrmG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768522412; c=relaxed/simple;
	bh=wyZTSNaahlwJAh0cMf67fv0LFlau0J3pldiB0gJ7Ut0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAghTeA04P/mk3yxE5OwTjHySD+Z72Q+o2m9m2EWG8P2CuucKtenUNOqBFMgX4hm3s6bDwlLABqQriWNb16ZumSI3t0E8HjUkOg81+ZzNto56cOceY6wkeCuyvX2O0SgQCM+AIY0g+NXsC+No68GMciFWyZ4gT369R25PcLDuZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMArgDoA; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so357951066b.2
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jan 2026 16:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768522409; x=1769127209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuYXJTx9p8g5I9PbL+x4hBzLoIE63ueUkinqkyb6yNs=;
        b=iMArgDoAz4hrMO8EGRCHD8pa+sDT+8ReM/im9xIuVgMnoTZd3dHxL10Ot/z9+EIDBf
         WnHssDeZUHQl3becA5PRNASjwMjpWBG1t8cxxaJadbYwVByngvO/P+NliiZNkpTO6UOg
         jtBzshp3bfz/yUR6T6BE4Sb1qS4EH5Gbh7K+oUCMQYwGcXrwP7WKSjlNn/jY+HyNdV6O
         dPEfQ5P/UBsdBwBeKf+tosiBPL0D6W1EXujXOt5JdB3nTlgy5nu0SYhFrRSnaf6yGDFf
         ZC6JYXuhiFlb0GeleUZH9Ec8th2oUHq129sJsTn8SIVx2f4i9bYylFr5BOoSweg32nFy
         Pxdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768522409; x=1769127209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LuYXJTx9p8g5I9PbL+x4hBzLoIE63ueUkinqkyb6yNs=;
        b=ktTyCLCbTt8Py0KFY1vLE/Y9AeZM0GTJcOWLDqf10EKfJRNYXm22wC3C+loir7TuEB
         HlepQKd8hFK2mstSKXM2RhIxQW3B99NZBCyC6cDuQGf55FPplWpttZLW7WE6NmLY33mD
         dYg4PHuU7OijpmwjaQl0CGN6t/VqOfEiEZLl0H1Fg0e3w703MkhwGENRhAIVX5RcUelG
         6Lvhd5keKySZbfc8u05Cx+ROFzMBnizmvX6qB53t7cva+lCo10+PgQtTzSDp84Q82YdM
         P1sdo1lpZxQFzSpKRHHE3CUoe/0AFbZx/WjH1QoOoqKPyoCbG2vmEOVxFMfHiDC5QVXk
         SGWA==
X-Forwarded-Encrypted: i=1; AJvYcCVRfXE9wKWNLRSjQBRJt+YTcLgcB1yiM5Dv0swFChLy1Y1dKcAoT5F/99Z72jMvOnj/MLfh20JUWSlo@vger.kernel.org
X-Gm-Message-State: AOJu0YxYwFNFxpXvvENxaQXU7PcKrLKDCWmdukPlz+bM2aVpd/AK0kDS
	nNpvQV45Ia+Kwcqkimr0J34Emqt8RrbNwSTeSfeZogxrqfIIiqUUaVnALJiebg==
X-Gm-Gg: AY/fxX6OyY83UM4HHX9YMseLjqEYwookd22PYDEGqIVMaVncir2szYE06Oy+MMEhrVg
	vWnYC9vi2/18d9YzWZVuuy7IsbzPStuei77+F732GcjWbQy6jrD9x0UXyVqK9fFk1FVVbVxhup9
	GmhUKJtj8Olazm1es5Vgdna8+Mfv+81VbaBovc1yxq7LxfPeT0OdAoxHWR9H+6MZ3vxc92UTSgX
	8USF+bwIW5B93t5Xm4vtuGk6B5WzTgEpV2z8IEnjGziQxNKKxFW5AAdiyOUPtN0ev6rtH1oynoi
	hVkKSWUlZuk9vyQnBauCRF1Abkz+Se5xH9ukg47l/S2YnH/uJtB6D9LSgtTmt/rjYpnKTWk6RZb
	iNdL/tNzRhIY3Bgy/GP+AOLBS9aXdn62ASP07c/RCtTYDV5IdjFQGFqQLrRp/u/c257HCoI4J8k
	7UdlklFHlsbEfYlu4ta1xHcOWKGILuvHsvc+pX7i195EirPiUsGTey
X-Received: by 2002:a05:600d:8445:10b0:480:1a22:fce8 with SMTP id 5b1f17b1804b1-4801e3494acmr11682565e9.26.1768516821247;
        Thu, 15 Jan 2026 14:40:21 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dad0sm1443737f8f.27.2026.01.15.14.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 14:40:20 -0800 (PST)
Date: Thu, 15 Jan 2026 22:40:18 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Chuck Lever" <cel@kernel.org>
Cc: "Dave Chinner" <david@fromorbit.com>, "Amir Goldstein"
 <amir73il@gmail.com>, "Jeff Layton" <jlayton@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Chuck Lever" <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, "Olga
 Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom
 Talpey" <tom@talpey.com>, "Hugh Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Theodore Tso" <tytso@mit.edu>, "Andreas
 Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.com>, "Gao Xiang"
 <xiang@kernel.org>, "Chao Yu" <chao@kernel.org>, "Yue Hu"
 <zbestahu@gmail.com>, "Jeffle Xu" <jefflexu@linux.alibaba.com>, "Sandeep
 Dhavale" <dhavale@google.com>, "Hongbo Li" <lihongbo22@huawei.com>,
 "Chunhai Guo" <guochunhai@vivo.com>, "Carlos Maiolino" <cem@kernel.org>,
 "Ilya Dryomov" <idryomov@gmail.com>, "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>, "Chris Mason" <clm@fb.com>,
 "David Sterba" <dsterba@suse.com>, "Luis de Bethencourt"
 <luisbg@kernel.org>, "Salah Triki" <salah.triki@gmail.com>, "Phillip
 Lougher" <phillip@squashfs.org.uk>, "Steve French" <sfrench@samba.org>,
 "Paulo Alcantara" <pc@manguebit.org>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Miklos Szeredi"
 <miklos@szeredi.hu>, "Mike Marshall" <hubcap@omnibond.com>, "Martin
 Brandenburg" <martin@omnibond.com>, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>,
 "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>, "Ryusuke
 Konishi" <konishi.ryusuke@gmail.com>, "Trond Myklebust"
 <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "Dave Kleikamp"
 <shaggy@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Richard
 Weinberger" <richard@nod.at>, "Jan Kara" <jack@suse.cz>, "Andreas
 Gruenbacher" <agruenba@redhat.com>, "OGAWA Hirofumi"
 <hirofumi@mail.parknet.co.jp>, "Jaegeuk Kim" <jaegeuk@kernel.org>,
 "Christoph Hellwig" <hch@infradead.org>, linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
Message-ID: <20260115224018.2988ca25@pumpkin>
In-Reply-To: <06dcc4b6-7457-4094-a1c6-586ce518020f@app.fastmail.com>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
	<CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
	<d486fdb8-686c-4426-9fac-49b7dbc28765@app.fastmail.com>
	<CAOQ4uxhnoTC6KBmRVx2xhvTXYg1hRkCJWrq2eoBQGHKC3sv3Hw@mail.gmail.com>
	<4d9967cc-a454-46cf-909b-b8ab2d18358d@kernel.org>
	<aWlXfBImnC_jhTw4@dread.disaster.area>
	<06dcc4b6-7457-4094-a1c6-586ce518020f@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Jan 2026 16:37:27 -0500
"Chuck Lever" <cel@kernel.org> wrote:

> On Thu, Jan 15, 2026, at 4:09 PM, Dave Chinner wrote:
> > On Thu, Jan 15, 2026 at 02:37:09PM -0500, Chuck Lever wrote: =20
> >> On 1/15/26 2:14 PM, Amir Goldstein wrote: =20
> >> > On Thu, Jan 15, 2026 at 7:32=E2=80=AFPM Chuck Lever <cel@kernel.org>=
 wrote: =20
> >> >>
> >> >>
> >> >>
> >> >> On Thu, Jan 15, 2026, at 1:17 PM, Amir Goldstein wrote: =20
> >> >>> On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kerne=
l.org> wrote: =20
> >> >>>>
> >> >>>> In recent years, a number of filesystems that can't present stable
> >> >>>> filehandles have grown struct export_operations. They've mostly d=
one
> >> >>>> this for local use-cases (enabling open_by_handle_at() and the li=
ke).
> >> >>>> Unfortunately, having export_operations is generally sufficient t=
o make
> >> >>>> a filesystem be considered exportable via nfsd, but that requires=
 that
> >> >>>> the server present stable filehandles. =20
> >> >>>
> >> >>> Where does the term "stable file handles" come from? and what does=
 it mean?
> >> >>> Why not "persistent handles", which is described in NFS and SMB sp=
ecs?
> >> >>>
> >> >>> Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
> >> >>> by both Christoph and Christian:
> >> >>>
> >> >>> https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-1=
2018e93c00c@brauner/
> >> >>>
> >> >>> Am I missing anything? =20
> >> >>
> >> >> PERSISTENT generally implies that the file handle is saved on
> >> >> persistent storage. This is not true of tmpfs. =20
> >> >=20
> >> > That's one way of interpreting "persistent".
> >> > Another way is "continuing to exist or occur over a prolonged period=
."
> >> > which works well for tmpfs that is mounted for a long time. =20
> >>=20
> >> I think we can be a lot more precise about the guarantee: The file
> >> handle does not change for the life of the inode it represents. It =20
> >
> > <pedantic mode engaged>
> >
> > File handles most definitely change over the life of a /physical/
> > inode. Unlinking a file does not require ending the life of the
> > physical object that provides the persistent data store for the
> > file.
> >
> > e.g. XFS dynamically allocates physical inodes might in a life cycle
> > that looks somewhat life this:
> >
> > 	allocate physical inode
> > 	insert record into allocated inode index
> > 	mark inode as free
> >
> > 	while (don't need to free physical inode) {
> > 		...
> > 		allocate inode for a new file
> > 		update persistent inode metadata to generate new filehandle
> > 		mark inode in use
> > 		...
> > 		unlink file
> > 		mark inode free
> > 	}
> >
> > 	remove inode from allocated inode index
> > 	free physical inode
> >
> > i.e. a free inode is still an -allocated, indexed inode- in the
> > filesystem, and until we physically remove it from the filesystem
> > the inode life cycle has not ended.
> >
> > IOWs, the physical (persistent) inode lifetime can span the lifetime
> > of -many- files. However, the filesystem guarantees that the handle
> > generated for that inode is different for each file it represents
> > over the whole inode life time.
> >
> > Hence I think that file handle stability/persistence needs to be
> > defined in terms of -file lifetimes-, not the lifetimes of the
> > filesystem objects implement the file's persistent data store. =20
>=20
> Fair enough, "inode" is the wrong term to use here.

Usually there is 'generation number' changes when the inode is used for
a new file.
IIRC the original nfs file handle was the major/minor for the disk partitio=
n,
the index into the 'on-disk inode table' (the inode number) and the
'generation number' (but I'm sure the length was a power of 2...).

It's not surprising Unix uses inode number and file handles.
K&R would have used RSM-11/M where 'file directory lookup' was a userspace
operation and the kernel only supported 'open by file handle'.
Although that got lost between there and ntfs.
(Windows IO is definitely based on RSM-11/M though.)

	David



