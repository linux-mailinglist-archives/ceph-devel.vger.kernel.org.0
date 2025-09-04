Return-Path: <ceph-devel+bounces-3518-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6034B438B8
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 12:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B431D168FE3
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 10:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC052ED15F;
	Thu,  4 Sep 2025 10:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXcGOsDR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2E72135B9;
	Thu,  4 Sep 2025 10:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756981691; cv=none; b=qznWt/2l7UFxbl5fJzVGAGzxlZXGgkVXwL6niCfS58SWz/MOJbbBGyLWo6+m6VJZduMOuxTETDnUExSDM0HtlWq6xpjeHdWZq1PvT9eu81Cu5mFgjntGWnLvpvCDFRo5PVTOqEfkBAtE2AMUNh7VPrzdfOG/4k1Kk4rWe9D1muo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756981691; c=relaxed/simple;
	bh=NRzH55jONxH+rCjNDk211Letjrdg5CgZVJ2sebEPB4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sjVpEp/3r2F5BDUxEdEkCOS5PyhPmEVXVnDUiwDFyrtpMQ9uNazTSu9b+Cpg9b+ijkUqj8qc1eKlbCEGxLHCVU3vV4ZnQgrrL6nFGW3Ecem/yO/T4e7CxJ01bfLkc/2EvZVpYfNhbP3mXWvp5ThqIAjcaPlKNl/QCwwW2f7B+qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXcGOsDR; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24c784130e6so10750385ad.3;
        Thu, 04 Sep 2025 03:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756981690; x=1757586490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB6NwnF428v+yfjdc9D/K3OP6jAS1mel0lhGpjrU8is=;
        b=bXcGOsDRX12IGHIZjBtW2zPhmYjGpqF9Jz6I+xn7A+jnSNoEam6XUc8kdm8fn81xJO
         TjNFs+wPtW+gkxr/gwp0WU6c77d6z6oMoFCwekbfRwmrbsA3/29FdudBelhdVR0OIW4d
         9aKPsnz/k3NSopgmoBTL2I4duggdwXrf+tf/eV9FwgR5RT2rgsBK7tytRlnU1uPh7zMR
         JzixIrsUzuHpEpb/hf9mp1KAIjKtiriR/ufBz1V5q+C84I02KzPANch3NncNvjnek6Uw
         oCzA/dVmXaaj/AWEfLQ+xKdc+723iFYEmoFb2UkHq/mRG2UdcveGurIQ0GLibpn4bdug
         YuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756981690; x=1757586490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JB6NwnF428v+yfjdc9D/K3OP6jAS1mel0lhGpjrU8is=;
        b=c8x0HHjcm/QKfFniOKDaGtQkke+doSzlHMOxHSfEPBBPg8j3K8jVeXtzHzpZwmz+NU
         Ey7Zy/OSJQphaviCThsjH3p2lgTeTAo1TRDB7nioPzgiqllDWcPRlrdd8F2NhoqLssNa
         WMAJ43Y/EoMF0LUBC8vCCOtHqK/Y8n9VBnQxzpq93lMxZ4glSEiw4ympM/Spf/j6G9KL
         dmVspfYgyDfweU6oc9ZXbAd1mKxM1oJNkDh3J958V6n5Z+yuq0BEidxSCUrURXg7JL/m
         p/nX7pBL1js71ojpPV30Eu/qWgsfIMWHupX7m3uiciY6L71u7pXNM9nuVZmV1h0EMqKn
         hOyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpyj6ZcTnpvXP7u+V6bmXsfY5y6hpANGjOprlHU+x6Jd/JBRb3nBgQLAKitM4BIRo5vF0oWe5ZRBS2TZL9@vger.kernel.org, AJvYcCVnMX5xsS/Mtm0ndXaVrN0H7bvISfVes5yltSZir6qN2GntBw/Ko2SldaLNIJq0vF7GQmLPDlm5Xd5AmLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLIOalmxafgBjoVr/88iBrJUhhNf91MG1bhuhYGLynp//bIM1y
	FxcFdMsevjuBdYdAnqeV7XuR2e7wloKnVUjDzKitvYwFLNLzsBHu2gWSkfC9IhW5YGGH1XCOBGe
	LVQxKAVJbxFzJo8VtauD7Ew2O5+GEZrQ=
X-Gm-Gg: ASbGncvLOCPyE+3lUl3uGHP/1GLcPRm6HNmvJEPQCFLvHr33xyn2BOuAljMOrYceHYx
	0KyymrAkdqQF38cw7jGdsc0cvb2Ena15uREirzd4aZwJa+hfpO3t9rbe2ucjMdDZxcuP57XSwG5
	DvUsu/CBPHn39+iT8C6g2K04SNTGHC6dYJP5goGMOyeFUSxdtpEJKWhAoojfcNfnulP3PFnofmu
	pQBlCa7aE7Pe3zmlg==
X-Google-Smtp-Source: AGHT+IFaYFkEtDVz7Q2KPdDxYXNvVJPsCmyx5FmMtsCw7+ohSf3tqFm1nqPR9XzUqGCY0agzxRySD4GwkV0gpUuGCJY=
X-Received: by 2002:a17:902:e5c9:b0:24b:24dc:91a7 with SMTP id
 d9443c01a7336-24b24dcc751mr99772375ad.45.1756981689787; Thu, 04 Sep 2025
 03:28:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250731190227.16187-1-ebiggers@kernel.org> <20250904023110.GB1345@sol>
In-Reply-To: <20250904023110.GB1345@sol>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 4 Sep 2025 12:27:57 +0200
X-Gm-Features: Ac12FXz-pyeV3U00wIVRC3GGv63KNkeqEaAkMIZIbstLZ_i8PafVhipUNItEUdY
Message-ID: <CAOi1vP_7=hXNhD+f9BV8WP+5cyr6RhMridOa86EE7=nKJN92DA@mail.gmail.com>
Subject: Re: [PATCH] libceph: Use HMAC-SHA256 library instead of crypto_shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 4:32=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Thu, Jul 31, 2025 at 12:02:27PM -0700, Eric Biggers wrote:
> > Use the HMAC-SHA256 library functions instead of crypto_shash.  This is
> > simpler and faster.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  include/linux/ceph/messenger.h |  4 +-
> >  net/ceph/Kconfig               |  3 +-
> >  net/ceph/messenger_v2.c        | 77 ++++++++++------------------------
> >  3 files changed, 26 insertions(+), 58 deletions(-)
>
> Looks like this patch hasn't been applied yet.  Can it be taken through
> the ceph tree?  Thanks,

Hi Eric,

I have just posted a small nit/question on the patch itself.  If you
agree, I can make the edit and stage the patch later today.

Thanks,

                Ilya

