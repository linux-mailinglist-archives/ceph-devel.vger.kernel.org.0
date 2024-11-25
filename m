Return-Path: <ceph-devel+bounces-2194-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B20A49D8650
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 14:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 478141662B8
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 13:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A60F1AA78E;
	Mon, 25 Nov 2024 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHFcdXz3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345D62B9B7
	for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 13:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541053; cv=none; b=DAlFvf+FOhUuskwWnlEUHyXZ4Pf7TEj+J6nd/rzFpZAKyU9QB/3DIT/A+KHA2/o4X/oe7Ifd/su1dqFRune8W5PSkfbm+hhQOF1nVez0mw0ULmEXFGvjzvbkvfvwCM/sMGA44GvCe41G3QhrPhZewIZ1ehHxeAVvryKjJKrlyu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541053; c=relaxed/simple;
	bh=vM5vqnK7YZT/HxJwidVvcAN5usmROancOhyKqA/5O/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UiizP3Wd4OBk8YVKplOlZLDhg+tqWWOzmT7k0LFM+Sg+wTGS9bM8PStxjFdONfu0MG1pifwDoj5Qs6ZSmdoNBMV2jShduIBtPsB9PP/pZosj2L29fWjOJUB+aYOYy7CdEseT6EzmX9QZc7Z29n4GwtwHFoviYRGwmORUcqDVRKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SHFcdXz3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732541051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vM5vqnK7YZT/HxJwidVvcAN5usmROancOhyKqA/5O/4=;
	b=SHFcdXz3O+QcbuTfMZVZdbPd2OqOLrD3z761uYm4G6USK5uqHW0mLRe7hhmnBCrv/8oO5b
	ceyWIDqX9pfqS2FQTWoZASwsOa27d3S3SK0Nika2uPFu04t7hLY66/pfRY16aF6zKbr5zD
	PvYHtWUGQeAhg8pABKV8LsX+ZyR+3kA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-6_AT-S0FPSu5mqAoj_iG-g-1; Mon, 25 Nov 2024 08:24:09 -0500
X-MC-Unique: 6_AT-S0FPSu5mqAoj_iG-g-1
X-Mimecast-MFC-AGG-ID: 6_AT-S0FPSu5mqAoj_iG-g
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa52d371666so194380766b.3
        for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 05:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732541048; x=1733145848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vM5vqnK7YZT/HxJwidVvcAN5usmROancOhyKqA/5O/4=;
        b=qBefPsrrwcHXuHfSADhwMZ1n2Um+2THGRCsStvBQh3n6I0pZ6rNFA5eOQBHoYwqNyl
         I0nWOaKceg30WQQ295ZoRh9onFFXHZI3a3I7nbVs69mXL75kEBGkJ99l338csBfLEXI/
         /U5xd+77SHI0LvJSWYVICvj/quWS6Qwx2Oy74UVL0vEohXo4kkfWldw+nmuvvMGTS2xn
         w5/tY2y+Bl5TNeWN6n7b1CaF1mA3wdm/JzTgPTOVZIePuROjmTVyF0LzJXz2ei9bbHFA
         0fXhG7VdP6E7zfBV/Y8vUuFQE1l01Lhm+vsT857Raw0geBFHtGtL9+rIksVaYwcDW8oX
         Vj3A==
X-Forwarded-Encrypted: i=1; AJvYcCXEPL5WExlQmjxw4ot8SZuOCiJQjJSaBCGHxDhyOyYdoy0ARPKp0vZCGnEp7aFQij/wwi8UEOAYgoFH@vger.kernel.org
X-Gm-Message-State: AOJu0YydtAJm3uY7WlXPnBnZ4v15Hd2HGekj9MrtexkwNwmkwkx8UwR5
	B5q23y/L/3tMOO/IrRWBUndOZI0rsSoMNr8oY0MwMdmwvBb7FhrYMtjVSFLGd1eKT3CvczXvGJz
	XRpSKOgkTHN+uAjBhxMhGkc0QBDg0eFOFl/4yw5aSYMz22CGkCWDOXuGVFT40FcJto3kal5zNtn
	XKBp2+mVkp9619TbX+Se1ZXWiZtjvATYMP7w==
X-Gm-Gg: ASbGncuvhz1P2GCjkxrzPwUIZ8TAMgK1EFEtIlxa5UMn4r3QEaUHkdcF+91uwFfDWta
	VSHZu6yTue//aT0mjJy/1+9ReKmwk
X-Received: by 2002:a05:6402:1e8a:b0:5cf:e218:a4b2 with SMTP id 4fb4d7f45d1cf-5d02079aa9fmr12236089a12.27.1732541048527;
        Mon, 25 Nov 2024 05:24:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHWG9BjKbTAHomr5dFvqIAic7HfIRfWWWFcqxR41nDJd/bSeuou+SQwO4PnJvvgGO02X9v7YkAgfyJvNI4sgI=
X-Received: by 2002:a05:6402:1e8a:b0:5cf:e218:a4b2 with SMTP id
 4fb4d7f45d1cf-5d02079aa9fmr12236068a12.27.1732541048251; Mon, 25 Nov 2024
 05:24:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
 <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
 <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com> <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com>
In-Reply-To: <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 25 Nov 2024 15:23:57 +0200
Message-ID: <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Patrick Donnelly <pdonnell@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey, Folks.
This seems important, so I'm bumping this thread. Max has a valid
concern, and this issue must be addressed.
Jeff seems to think keeping at least a few retries might be a good idea.

Max, could you add a cap on the retry count to your original patch? I
will discuss the PATH_MAX with Patrick and open a feature request for
myself to alleviate the limitation.

On Thu, Nov 21, 2024 at 12:48=E2=80=AFPM Alex Markuze <amarkuze@redhat.com>=
 wrote:
>
> IMHO, we should first have a solution for the immediate problem,
> remove infinite retries and fail early, and cap it at 3 retries in
> case there is a temporary issue here.
> I would use ENAMETOOLONG as the primary error code, as it is the most
> informative, and couple it with a rate-limited kernel log
> (pr_warn_once) for debugging without flooding.
> I would also open a bug/feature request for a dynamic buffer
> allocation that bypasses PATH_MAX for protocol-specific paths.
>
> On Tue, Nov 19, 2024 at 5:17=E2=80=AFPM Patrick Donnelly <pdonnell@redhat=
.com> wrote:
> >
> > On Tue, Nov 19, 2024 at 9:54=E2=80=AFAM Max Kellermann <max.kellermann@=
ionos.com> wrote:
> > >
> > > On Tue, Nov 19, 2024 at 2:58=E2=80=AFPM Patrick Donnelly <pdonnell@re=
dhat.com> wrote:
> > > > The protocol does **not** require building the full path for most
> > > > operations unless it involves a snapshot.
> > >
> > > We don't use Ceph snapshots, but before today's emergency update, we
> > > could shoot down an arbitrary server with a single (unprivileged)
> > > system call using this vulnerability.
> > >
> > > I'm not sure what your point is, but this vulnerability exists, it
> > > works without snapshots and we think it's serious.
> >
> > I'm not suggesting there isn't a bug. I'm correcting a misunderstanding=
.
> >
> > --
> > Patrick Donnelly, Ph.D.
> > He / Him / His
> > Red Hat Partner Engineer
> > IBM, Inc.
> > GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
> >
> >


