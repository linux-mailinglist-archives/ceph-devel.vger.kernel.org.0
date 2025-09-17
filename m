Return-Path: <ceph-devel+bounces-3663-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D27B81CA1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AA491C053D8
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9D32C08AA;
	Wed, 17 Sep 2025 20:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="MBzCfgQ8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1DE7082D
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141423; cv=none; b=CcF/efTPq1cDRyIgvIgXWF4/++gykFacqtyCGnbxRKyHsEgeLobUgY3YITza2ETtEFsjPPp1E4ttKxxe4GuvepCuiEdGdVP8h7lz76QsFEKSy5y1v1S9mSt3A/9S/jKMOCyK6ljIxLnrv+4NKJ4Mhc1Y2923ETELrWgzX8yzMB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141423; c=relaxed/simple;
	bh=4UTP14/ZBWdBW20f6LTJKvgiuhF7FTrxq4n4nfTui4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y9pXUc/x3Fqgud/JNOilwBx9L2IQIbLBLAUNr6tfikWq/jadIyVm6BCz2qZkhbNmr8jYFLPd+XSzcC4DAvl7wO3YoBIQuZbcJDAV2Mp0rG4XIBytqKY0QYeZAJFe2DBd636CONW+MTQ9eyrASWALvpKNzmOI14WKTf+R/1R9MZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=MBzCfgQ8; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b07e081d852so40116666b.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758141420; x=1758746220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Chf7X+qGiFJJFnzlWxmYJPQYQ0EzCnC9UbWxIFQaqrI=;
        b=MBzCfgQ86C3Clio1lwYTkXgHRwrl7dhwqv2GbSbVdX1vZXp41Y226ALZMTnk4FZID+
         s5lpgTiaUpn1w/rD1lsKVEj8jiGx2FGNr2bDSwptgq2XjY4ezMOYg2LdMCO4bpCphym8
         pMq+Y9YEBE9kWFbnWhq1w8cP4phaW4szZ5DQs0lzoYDTm//FnFwJfRJZBzqh0I1/BWXN
         xpE/fmZ6NTq6yyWN+8taPQQZRSsexFoN9z8ymnDg+cFm6AE+ZIJAfn4NFx7QRF/gDWIM
         hT6S2X2SSgWxUjuaciReKNISHugDqkTEhALoalcTtOce7j4uBfEWgK1XdjhCpaZ5kDs7
         yZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141420; x=1758746220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Chf7X+qGiFJJFnzlWxmYJPQYQ0EzCnC9UbWxIFQaqrI=;
        b=Kx4PYv31HNoro9ErE9M8WGV9bnFEOCYMEMJ3+vGt6xY+E0E3nIFHqwj6gztPDxpDUa
         K7600bBWk7lJbq497taW1mNY29vvRDjLmShLk+4P1B21evRcxp6SNppxIG4ciwdQtK4+
         aXMi1yVSwIt5psBO7y7LNM9uQfsdZ3NWiTTZ9RXpO+2NDZTxKuB6FDQLw4NNdsT4CCtT
         b1WuB6om1abyPBNzsp0bhA2lm9xZX8/luxHOQAM3hie7MYstCLMxCGRaNfT+KXfRsRpV
         a9R7CFtBZqN638oHOF9a1gKRUclgxLoevq4Efg7ujhMYHEcf5eT8tQUyBf+Vp3/73ql/
         iNiA==
X-Forwarded-Encrypted: i=1; AJvYcCVyTpTKegWzZg5uViiMtJ6PMzhlyZmIutvLu3aRvecWjMX7a+Rc5Pxa4tIf/+e1PnM+CunGvAloM/W3@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8hCrR8Qn748exQu4eEGGwnFbQW7pSnq+2C8GJcoCp1XiHVu8f
	SEKvTrEB2qFaO2Yvs9m68kPio0taAeIkhryRHQR/6CiulKb8wvPH0BtUIArrvOFOIHeup+I67FE
	LByd8uCGdtEg4vuJiHqx8BNXYOmA41gGhqlJh/vW1bQ==
X-Gm-Gg: ASbGnctFrGne7BVg/VLyZ2et+4bUBNPCVrKYZEAf3vQHUaO6R1Yb9FshhcxKxVwmvXb
	UgPgbhaEY07LsXPT7tZdOVPWjt81jxBn1Sc6lmzyTrr+rk8qPkmWLcpUS+5NCDvhLBsYM/kO8hF
	8URiNJyPkDojCXma74rf7b2mrtOiL1Wsb6TEFaHO6/43gc2nLox60d1p24L/aKSyBK/7xPMScTh
	daRtrpIGMo7ZWJk8LGRCRaD3v7n/yScOqzF
X-Google-Smtp-Source: AGHT+IGfptemIFohfTy+lGP+G94GDKuCT6cuywROwctnniSHmTHsaA0aWmc8jBz7sUxZychQu36GLP7/p/srVhhMhOs=
X-Received: by 2002:a17:907:dac:b0:afe:e1e3:36a2 with SMTP id
 a640c23a62f3a-b1bb6beec18mr411560666b.31.1758141419817; Wed, 17 Sep 2025
 13:36:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV>
In-Reply-To: <20250917203435.GA39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:36:48 +0200
X-Gm-Features: AS18NWCHuKu5FkRi5MWoSntMnfUkf_rpkIBRpCjAVUQOvwmxI5LYn5BBnB2B2gI
Message-ID: <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:34=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> Suppose two threads do umount() on two different filesystems.  The first
> one to flush picks *everything* you've delayed and starts handling that.
> The second sees nothing to do and proceeds to taking the filesystem
> it's unmounting apart, right under the nose of the first thread doing
> work on both filesystems...

Each filesystem (struct ceph_fs_client) has its own inode_wq.

