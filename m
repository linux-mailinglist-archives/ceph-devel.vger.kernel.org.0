Return-Path: <ceph-devel+bounces-4163-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D5D46CAB3B7
	for <lists+ceph-devel@lfdr.de>; Sun, 07 Dec 2025 11:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B8CD730480A4
	for <lists+ceph-devel@lfdr.de>; Sun,  7 Dec 2025 10:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4C62C11CF;
	Sun,  7 Dec 2025 10:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O8ZtMLFA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8Kqvah3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA8261595
	for <ceph-devel@vger.kernel.org>; Sun,  7 Dec 2025 10:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765104683; cv=none; b=X/DDcMTi0XL0w/g9mnY9ADG1fs+a0Er0LetbXiGcyJcC6/h0jHaTceE/k8QgeXHcmWaWZ+qGLl1501Sil23bD7D2NYFYrrelrVQzWaPH4g7U3ZS2sB/HznF2SMrQhlwUnYIVnnuuRK5AYvWc3eR4o9KhVdrXGzwld0hkE92uook=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765104683; c=relaxed/simple;
	bh=A27tycarWLygxXNy1wfuEPie8VqQ6OnUSADBg7nJ4V8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XxbDutiO6KLqfgAQkjpdxbg885P3zmpjzs6rR6LgQhpUDbkKGvEeJFIvyNJbXfPOfCuMNStpkNbpLqoScTYPFtzDHfgIv3jfycCHu9C7C8J2D9vj8W9SHB4G2t8eb+p88iuofc03Id5+7IinvukcExYENuuY1tRuIM4uTK1/jFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O8ZtMLFA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=J8Kqvah3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765104679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1UQOnxqZ6TIHZudTuOmylWKYtXwvpqqonsNnMM6iZI4=;
	b=O8ZtMLFAEt2YiZUseFbHn/BXF9EjaPaZ5IzKI+/KomF4q8dw89Gkz/Z2UZxG+KQRh6yNHm
	sHLQaxAMrEDp7uHi0ftUXTiZyTROqREu4jyhM+EvkDVZ2lA5uSbszkeOApEZmzQRlGQDb4
	szm/gA8Dfd/KtbYt3EHKoj2r9rX4aXk=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-IiG15YezPNqAW5Lz7frn7A-1; Sun, 07 Dec 2025 05:51:18 -0500
X-MC-Unique: IiG15YezPNqAW5Lz7frn7A-1
X-Mimecast-MFC-AGG-ID: IiG15YezPNqAW5Lz7frn7A_1765104678
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5dfc0924912so1807000137.0
        for <ceph-devel@vger.kernel.org>; Sun, 07 Dec 2025 02:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765104677; x=1765709477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UQOnxqZ6TIHZudTuOmylWKYtXwvpqqonsNnMM6iZI4=;
        b=J8Kqvah3FGqjiPYYQwoBPFS6hZPAdcLsjG+ROScGBq2CZnqKtCnil2zTA3ycL7HpkQ
         aUnBQywH10ueVJjX/Fm+etTecxZuNAJVK5pDNlKo5U9S40iQ/BuXRlP6+8SUD4pkAcUs
         49Ifdi5a2e8Hjg3KmJ6PsJjeJF8fyUSwUhaYj0kDoT8arfzRROpOvl2KkKjUP9drEHOL
         HS/GH6FydbbeVig5dXrnCdPZ8QGXXf1OsrPOQLuqDkeIwHNpnntLc6IlOLO7law9+B//
         2LIkRBS8Qtaj8dG/C4MHuVvrVZmoP4WomC4KoJ8cnTh7OYSPhupq1hU8bUQtJRUMZrko
         yCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765104677; x=1765709477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1UQOnxqZ6TIHZudTuOmylWKYtXwvpqqonsNnMM6iZI4=;
        b=JDKpIvo6Wx4dryPwFy+YVW5lXv0faE3xOTbG+9Tej/TMVjeEbDW7QB5PO/ZvtaOS+/
         COG1sYFPUU8xSRV44CzghTyORXyL+bLkzsEROaHa5hN4QjJmd0rbDMlUFZL/vrYL0S75
         56PHRxMj9FP7TnRSbHJfAj2F693sXDEEcFCE5aFVGIBfl3n9MtXCSBvP9K+RIlI8wLp3
         tdYg1P1oEl60RQYy+Riin8HlLD4AH4M+ZKm2DPN/btP2S11clKpfgSMvT7MEAdpSg/va
         QQb0u1M4q1FCFhtZ4BVNYDaEhX2FJ2rcuiqVDl38rVF5POqnTL5eWXbvYkLbZg3bW27h
         EaCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEOJDRLHOG0afQe5L7iuS9UzzX/4Cr2QIfEwZxi5yXRYdl/OZUDOgM9g7i08VIG0CaqYFzmIu9XMvC@vger.kernel.org
X-Gm-Message-State: AOJu0Yz//2qSoFXmtn5D0ZRi+Ab9UqoTw/NTINDnyCSwHtlXlHZBJ5lF
	JW+0JDO5Yle3q61vR120liaoX9aPLEos2Dxxib31kiHSe7fXzJFyh9tMlmZWh2bblynNvN662DV
	I/Pc76QnO/Qx3MtixBEPulVy90gDFoC9rP3nFa5kdQyGB9pCmpBfAcXMQVRm8Ch3vZE2ij63CCk
	ZWMiKaYT0tS1l3rQfjn+EwS/6mOIn1bmyR9dGPUwXt6hdyP6Nf/PG0mw==
X-Gm-Gg: ASbGnct0iXDtRZbxz+U0546cYuqh5BZWr1cFNwlJsOvngx6BJKRDsu5nsBfGUS18dGS
	HxKLGCD7F1PQimLwHw80CMZe9K1VyzIwVLAJwhWoRDYe6ed0qvJCiUNkTlBX0Tnaa0OKG6pIi2O
	n+bw2yQmwd6mcTcR8zaWccApKZwFqEKpBdwPHklDfTn7PU8hYWOXpqKV6ngUjPLD2RwgtSbunBW
	hRncp9EBj+u
X-Received: by 2002:a05:6102:2c11:b0:5df:c4ec:6607 with SMTP id ada2fe7eead31-5e52cbb5261mr1137159137.21.1765104677472;
        Sun, 07 Dec 2025 02:51:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVA18jTe7xx/45QEtDTsPVpevQVkZ0dSg5zwezIDgGs/e567ayojjxu6ycsji6PbrFkKa9uvh07ZRDuf6k6dI=
X-Received: by 2002:a05:6102:2c11:b0:5df:c4ec:6607 with SMTP id
 ada2fe7eead31-5e52cbb5261mr1137154137.21.1765104677104; Sun, 07 Dec 2025
 02:51:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203154625.2779153-1-amarkuze@redhat.com> <20251203154625.2779153-5-amarkuze@redhat.com>
 <361062ac3b2caf3262b319003c7b4aa2cf0f6a6e.camel@ibm.com> <CAO8a2SjQDC2qaVV6_jsQbzOtUUdxStx2jEMYkG3VVkSCPbiH_Q@mail.gmail.com>
 <7720f7ee8f8e8289c8e5346c2b129de2592e2d64.camel@ibm.com> <CAO8a2SjN0BQqHJme-8WwMP2PKeR_QvKHYrNr96H4ymLTDC8EZw@mail.gmail.com>
 <a343801b052287308fc9ba2fa5b525c90969536e.camel@ibm.com>
In-Reply-To: <a343801b052287308fc9ba2fa5b525c90969536e.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sun, 7 Dec 2025 12:51:06 +0200
X-Gm-Features: AQt7F2pITTwqEivjOAvRLnio9OajABtAJAKi5oD5nla3MrMQyFxYBwPI2nrnrLE
Message-ID: <CAO8a2SgVx=9+RJhMyM6rp5vVQ45dWuf=iStLnc+GcbsCU+WCPw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ceph: adding CEPH_SUBVOLUME_ID_NONE
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'll squash the last patch into patch number 3.

I'm attaching instructions on how to create and mount a subvolume with
ceph. Sending I/O using any of the existing tests will trigger
subvolume metrics collecting and reporting.

Create a subvolume:
ceph fs subvolume create <fs name> <subvolume_name>

Here is an example how to mount a fuse client and get the subvolume
path: (FUSE client is the reference implementation)

/bin/ceph-fuse --id admin --client_fs <fs name> --conf
$(pwd)/ceph.conf -r $(ceph fs subvolume getpath <fs name>
<subvolume_name>) <mnt_point>

Mount Kclient:
   1   =E2=94=82 IP=3D10.251.64.6
   2   =E2=94=82 PORT=3D40258
   3   =E2=94=82 CLIENT=3Dkclient1
   4   =E2=94=82 KEY=3D"AQA4zyVpTXWPGRAA4c8aozVMYt+cri+3tAv6yA=3D=3D"
   5   =E2=94=82 CEPH_PATH=3D"/volumes/_nogroup/ssubvol_a/f089e65e-2fc9-447=
4-b728-117de5ad25f6"
   6   =E2=94=82
   7   =E2=94=82 sudo mount -t ceph -o
mon_addr=3D$IP:$PORT,secret=3D$KEY,name=3D$CLIENT,ms_mode=3Dcrc,nowsync,cop=
yfrom,mds_namespace=3Da
$IP:$PORT:$CEPH_PATH /mnt/subvol

On Thu, Dec 4, 2025 at 8:53=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Thu, 2025-12-04 at 10:18 +0200, Alex Markuze wrote:
> > There is no separate test needed. The client only differs in that the
> > mount path is for a subvolume.
> > Regardless its outside the scope of this patchset
> >
>
> If we implement any new functionality, then unit-test or special test in
> xfstests must be introduced for any new functionality. So, I think it's v=
ery
> relevant to the patchset.
>
> Also, I believe that fourth patch should be merged into second and third =
ones. I
> don't see the point of introducing not completely correct code and then f=
ix it
> by subsequent patch. It looks really wrong to me.
>
> Thanks,
> Slava.
>
> > On Thu, Dec 4, 2025 at 12:55=E2=80=AFAM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Wed, 2025-12-03 at 23:22 +0200, Alex Markuze wrote:
> > > > The latest ceph code supports subvolume metrics.
> > > > The test is simple:
> > > > 1. Deploy a ceph cluster
> > > > 2. Create and mount a subvolume
> > > > 3. run some I/O
> > > > 4. I used debugfs to see that subvolume metrics were collected on t=
he
> > > > client side and checked for subvolume metrics being reported on the
> > > > mds.
> > > >
> > > > Nothing more to it.
> > > >
> > >
> > > So, if it is simple, then what's about of adding another Ceph's test =
into
> > > xfstests suite? Maybe, you can consider unit-test too. I've already i=
ntroduced
> > > initial patch with Kunit-based unit-test. We should have some test-ca=
se that
> > > anyone can run and test this code.
> > >
> > > Thanks,
> > > Slava.
> > >


