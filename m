Return-Path: <ceph-devel+bounces-3659-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D78C2B81C1A
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA9867B9AAD
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FEA2C21D8;
	Wed, 17 Sep 2025 20:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="agoz5p2l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C6D2749E4
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758140877; cv=none; b=BwGfatqpOlPy2OyiRxOXCAVhYSAvwGIoJUnssMAjQBevecrsBLErd55zO/r2ysq3tuEap0mEtt8pjrSXFugLvJrbP7CNTSG6L0/x1Yn/pS+wjF7GwN+VSu4iN0FpHcrDW3Y/Pl/ZcIRStn01UjRlhOLuPDpGWS//X6fSGG9SguA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758140877; c=relaxed/simple;
	bh=7ftGvN/R/Ps0GPIX85RpurbPLiXS1I3fprN0bjaLYGU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fC0utrr9Mgrqe3yC1t3VauA4f8ncoSWiHfVXwMnmIQ1WpWJ4WelZ5eqqAyAksKr3+wbC8uBA0wh3TDVRK02kO7cvuid0ZdGrtH54efJIcU7QSsLlzAwb0r1u3v/RFlvotr3DBsOHnfmMfe1UctLO/BQ1iiJktiftfsmgEAcKkSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=agoz5p2l; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b149efbed4eso34571466b.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758140874; x=1758745674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4mlHJ7N2GtjpEnD9iNY8gv7p0x+AwcaIWO1wg2Altw=;
        b=agoz5p2lO+XoTPQ7Zg4tde1jUMGrm1CG/PinADYgfLY/uup0E54BFjrUKl179+uZul
         vCZCD5S/b1zLgFYMMl1rZnMR5D92TmfZGfhoOxuHyN19OBKicPHS/vFusG+MbBR8Lctt
         Yb56njz0jtkPxVtWEtG2EErvFTneR1bsyTlXc20Cnw2DlsqqIAUTBTrMPIjze56qtkcD
         gbtx5vRdK2w1k51QBJP6q05jQxhl2Vk5grH0M5RGL5+eJTbQuCstt95+CL9hp/hb8s5V
         aFGUnneQk2rSJIr3YREy+zgPRyg/fceIh0hvup4/HPfUF7gJq4Fu28L2sPa2cEeUNr7B
         BDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758140874; x=1758745674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4mlHJ7N2GtjpEnD9iNY8gv7p0x+AwcaIWO1wg2Altw=;
        b=dua+dqnPAIWx3O4/9gs+ReCIySl2JV+Mqe9eHy+x7zGbgbaY5mZGbaXtXDViT7CcVJ
         0ODBZUXFTDHnVez0VyiaJ/nZfa7D0U1DYTTAmK/4jBAbAX4+dH5j53dB/sBjQV8EDich
         ZWNxCTWVdGTkt2FqH06yW9CrartEHXst3hzLRq4CKIWMPozdAzMLMvagJL85oPIcdbn9
         SMHT9puuLsw9rizcYXd1oNmkMoBr1B00n+2N+isa+szlftUNU1OOVbGZHQLqLHdQ3777
         /RgtXLG43tmdQzdkF4cihayo8JGiydnxDE4oA9IvgmYW60gkgOZWhN4DBFHtb8s8A0Do
         4ztg==
X-Forwarded-Encrypted: i=1; AJvYcCVnI+q0NzH3zysrZzpXbNHNj2vj9YieG00ccGsl4w9cLvNFVzjFzbPkuQSgwS6I1d9yvmM9xaT/JHxV@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa8caG87Ct8+OgGbrMhpX5kMU3zc8qPAbODsUDqHzLT8GUNzRc
	H6HKtxVcnckzYu1fuiMItTPY6WevWWLhSI89k5kF9na93RqWabvndYy6VzGdldwZyqWFpsvawLD
	5XVpGWxC9Vee1URx8517EWJ8qgeqmFacRXUKcIm8vSg==
X-Gm-Gg: ASbGncuxk8orkje+PIs493GnoLbBMuR89uVPbgogDvVyR47CHfxGl1A8yj/GaObSl5m
	cpG/6XITLrFxE1X4ZXL3xFk7ITrdtXWgrSWe6JW3Ijqzqh/MWzK2fdcXT0221F4ksbw6aJ3dFMU
	d1MYoznAkXfC/qznfydEApJSemqWx8Xmw1T2msDjS82hKutWB26kkZnIgxO0zkQfDi80T9w3c+F
	LX739Lt4unzu+J09sjaU1vjizT3KycWZYuBbw+TAk7YPN38L2EHKmw=
X-Google-Smtp-Source: AGHT+IHTHtpXLrzOlNF8ItBS1Dao3rHs8rUuADCH4WTPP8QnLumlzZRuwQZByHIaY7Yr6edfpyVLQ1M4x0U8xNNPnIY=
X-Received: by 2002:a17:907:7b8c:b0:b04:6338:c95a with SMTP id
 a640c23a62f3a-b1bbc5490a6mr373843166b.45.1758140873916; Wed, 17 Sep 2025
 13:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917135907.2218073-1-max.kellermann@ionos.com>
 <20250917202033.GY39973@ZenIV> <CAKPOu+8eEQ6VjTHamxZRgdUM8E7z_yd3buK2jvCiG1m3k-x_0A@mail.gmail.com>
In-Reply-To: <CAKPOu+8eEQ6VjTHamxZRgdUM8E7z_yd3buK2jvCiG1m3k-x_0A@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:27:42 +0200
X-Gm-Features: AS18NWD_SzRUSSGY7GiasnnPbKogXv5-_s8RWyt66I7bKnW_Disajb-Bt-pl0Fc
Message-ID: <CAKPOu+8vf5DbR=cJ5dArut=QamTu-EdpJVta_Dsk+dQDpY68UQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: slava.dubeyko@ibm.com, xiubli@redhat.com, idryomov@gmail.com, 
	amarkuze@redhat.com, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Mateusz Guzik <mjguzik@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:25=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 17, 2025 at 10:20=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk=
> wrote:
> >
> > On Wed, Sep 17, 2025 at 03:59:07PM +0200, Max Kellermann wrote:
> >
> > > After advice from Mateusz Guzik, I decided to do the latter.  The
> > > implementation is simple because it piggybacks on the existing
> > > work_struct for ceph_queue_inode_work() - ceph_inode_work() calls
> > > iput() at the end which means we can donate the last reference to it.
> > >
> > > This patch adds ceph_iput_async() and converts lots of iput() calls t=
o
> > > it - at least those that may come through writeback and the messenger=
.
> >
> > What would force those delayed calls through at fs shutdown time?
>
> I was wondering the same a few days ago, but found no code to enforce
> wait for work completion during shutdown

What about flush_fs_workqueues() in fs/ceph/super.c? Is this what
you're looking for, Al?

