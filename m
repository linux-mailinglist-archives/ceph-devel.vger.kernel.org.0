Return-Path: <ceph-devel+bounces-3312-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34438B023B0
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 20:32:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 784465C365F
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 18:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C742E92D9;
	Fri, 11 Jul 2025 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8NgsR4/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B0B1ADC7E
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 18:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752258760; cv=none; b=h8cjeencQP89mHZWD3n0sdr8gFF8WfAdVnlNoi3braiey6NYwc9hSG+EACrkMU9nqFvL0ouhn52KgdcGDyM6JAOTLSS1VEeJ05dLj6kHO2gNi5Oazos+K7amNe3D/IYU/Uw6wAstPdo3e3AaxhAdQv7Mm6+X36d0rdB2Lz3VLLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752258760; c=relaxed/simple;
	bh=EoqX89tnezZCplcHahHeSxLZ5tyKDNt62izJncPjSTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lxRo25GEIASz8tDioYr0UXMs180c0i1co6YxUmNrurgVMhk+04SgtJRrel6Xox5d3hz387ru66stzsjDUXC8gHDvFY2K5DLfbjre3U4+u6XG3Qb33jfSHXkBBsgAJ8ubA2z1Rd8TzAh7OuOpHr6fYhuavlKdFqq3nH+EKnKwph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8NgsR4/; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b3507b63c6fso2741925a12.2
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 11:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752258758; x=1752863558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8deietyAP5Locjdf/u/sp5upUljBYcno5FYwRlgTQ2M=;
        b=m8NgsR4/TXn0CgsQZJShc5wyDhgqss3w8L2hixFhkYs1s5pY/UcwpbO1dH/HwE3X11
         c733omkwpQ4XUHGJ2NnxiVEaE/HdjNThCCTQoeZ7UaWTSDOn0+SEgw6i/Ntn1mqu16Q/
         9SnPTACSudRTERfLZGUjrtjgVN303JyvSncD1YLPzTS7w4/cUtYglok512INcjEMogSt
         DXFVO/aL7fZ5Moxv3XSuLBvd9hYULdwGh/Qxn6BJXRo+ghkbumlswmJ4akKZfUZrNPCy
         8hFXotFiBMR0jFgd3PkbZcTKEa/1FdH2fr90Uuul3fQx3THegTFVho49rbeTPVuRk/Ab
         ZyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752258758; x=1752863558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8deietyAP5Locjdf/u/sp5upUljBYcno5FYwRlgTQ2M=;
        b=rHQJCVk/oBo+oGaAl+E2qdekAayPHFbjWwkpTJZU012FWH00t6spsWYyvsgI3lDvry
         IhtSruA9FSOQBgg09c6iUeh6I2aN8+d5cot7t/GIOItNODq1qPbftoBIi5nGmd2pJ5X8
         Hm3M4rvmenNywtcgnNFhFJnL/qKyw/cXW2HC+xwzvS54IsMcpZ3wnj+rFhBGrWPCl6Mn
         4onDFejBMR2/bZEPlRpuVSVHyQTbZHgJbUr6bSR3y8u1m1B3I1mNOcY7/ELmE8XnGhGS
         dB9MOrwkuKqcWyArjyW5SuIEVBZjvpVnVcqtx8Q47A0AZwyILfKA7b5A5uy/n8XCh65l
         p46Q==
X-Forwarded-Encrypted: i=1; AJvYcCU0JkYTsqWKWl2SfaonfMUR9lKOxuCb4pXNzJvWm8birv7K/G1rQoL03JXaG1wQGGF59FGdJvUx43Y/@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv3Yyf5ShI/QyE7IsowqjeAmgV3TY/FotaqVGvGejrOVli1DyH
	Jmgv0F1Fh7M/Nhy0iIeStCpcp9Yt1rSq+Faf0QpF28ctFFR9CFS9WtifXzwoYQjFL68UhPSmldJ
	ifSJZ/nMhbqr+U//AFhWARux0GN4F/l8=
X-Gm-Gg: ASbGncsom44usggKaSF4/sTpZ0VemQWx0jxeCWheY9fftYwWXo14iXP6rzuSuCMX64O
	4GsREWq+Bob+zm9aEXwwjdUZ1ky8yi3ntOylfP5Wy/b6WyaiYO3F54leFuSIsxwTik7xoNR/ZnK
	pJiEgmtGq31a/8rKib2YK3DCFgvxdSb1ulOzn0rSQxegR1vcFjJEm12TWqPlVdRjfvtyvRbK3GU
	RBEVayJEsP2Dm/fqA==
X-Google-Smtp-Source: AGHT+IHweqHE1b3PDBMfr46b5ewsfSynbGPpkWWECM+SlyRQOPQTIZniOYlTcTH/pZEfMaZ3yMIzvgAPziTNDD1uO1M=
X-Received: by 2002:a17:90b:5807:b0:311:f684:d3cd with SMTP id
 98e67ed59e1d1-31c4f4ccfdemr6040986a91.12.1752258758200; Fri, 11 Jul 2025
 11:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
 <4DFDAA8E-98D2-461D-A5B1-05C482D235A7@dreamsnake.net> <bbb5efeac49870dad9783e30df1d37c6fd949172.camel@ibm.com>
In-Reply-To: <bbb5efeac49870dad9783e30df1d37c6fd949172.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 11 Jul 2025 20:32:26 +0200
X-Gm-Features: Ac12FXzU6R2VzS6iGmVLi8JujqH_JcE6sUnDsAYRrR_5DRjFyI256r0I8lBKsMA
Message-ID: <CAOi1vP_a2s0Q+tjFdLAfU+Tzut+HTCRfkteQyr3NHG6rQbvm=g@mail.gmail.com>
Subject: Re: discarding an rbd device results in partial zero-filling without
 any errors
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "aad@dreamsnake.net" <aad@dreamsnake.net>, 
	"satoru.takeuchi@gmail.com" <satoru.takeuchi@gmail.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 8:09=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Fri, 2025-07-11 at 10:57 -0400, Anthony D'Atri wrote:
> > My sense is that blkdiscard is intended for something different from wh=
at you=E2=80=99re intending.  From the man page:
> >
> > DESCRIPTION
> >        blkdiscard is used to discard device sectors.
> > =E2=80=A6
> >        -s, --secure
> >            Perform a secure discard. A secure discard is the same as a =
regular discard except that all copies of the discarded blocks that were po=
ssibly created by garbage collection must also be
> >            erased. This requires support from the device.
> >
> >        -z, --zeroout
> >            Zero-fill rather than discard.
> >
> > It=E2=80=99s about sending TRIM commands to the device telling it that =
SSD or thin-provisioned blocks may be reallocated. Zero-filling or erasing =
is a different operation.
> >
> > If your intent is to free RADOS pool capacity,`blkdiscard` should do th=
at, or if there=E2=80=99s a filesystem on the RBD device, mount it and run =
`fstrim`.  Was there a mounted filesystem when you ran the below?
> >
> > If your intent is to erase data, any new clients getting discarded or f=
reed blocks see them thin-provisioned, so any existing old data is not visi=
ble to them.
> >
>
> I think I could add here. I am not sure that RBD should support blkdiscar=
d.
> First of all, "Ceph block devices are thin-provisioned, resizable, and st=
ore
> data striped over multiple OSDs." (https://docs.ceph.com/en/reef/rbd/). S=
o, it
> means that OSDs could use HDDs, SSDs, or any other type of storage device=
 that
> could not support TRIM command. Even if we are talking about SSD, then no=
t every
> SSD supports TRIM and blkdiscard command will be simply ignored. Also, Ce=
ph is
> based on block replication model and if we have the same block replicated=
 among
> HDDs and SSDs, then how blkdiscard command needs to be treated? Also, thi=
n-
> provisioning implies that some logical space could be not allocated yet t=
o
> physical space. And if you try to issue the blkdiscard to such space what=
 does
> this command mean? So, it's pretty obvious how the blkdiscard command sho=
uld
> work for SSDs, but it's not clear at all what it means for RBD case.

Hi Slava,

For RBD, discard translates to "free space at the RADOS level (i.e.
in the object store)".  It absolutely should be supported -- otherwise
things like fstrim wouldn't work and RBD images/devices would remain
thin-provisioned only for some (probably not too long) time after their
creation ;)

Whether discard at the RADOS level then gets further translated into
some TRIM or equivalent commands being send to the actual HDDs or SSDs
that back the OSDs is up to the object store backend (e.g. Bluestore)
and is configurable.  See bdev_enable_discard and related options.

Thanks,

                Ilya

