Return-Path: <ceph-devel+bounces-1984-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C7D9B203B
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 21:16:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01E4A1C20FDC
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 20:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23B2176AAF;
	Sun, 27 Oct 2024 20:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IpfTZT6F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F363D17736;
	Sun, 27 Oct 2024 20:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730060182; cv=none; b=PDgY8365XMg2yGO+1QuWROLT4KhjGkIhegf0j+WhE7JZkWhY2K0spXopZBhagVwKAN4Lxgiz/IzglcNaWykQV853JCDX25r9NrYuHO2JP4pYRkqIl9N9L26vx3K12izt144Zia5TfLAqeY+Owy8n3kyZ/B7V/Ear6vfeWqOFPbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730060182; c=relaxed/simple;
	bh=E1xMQGOuYOuYKoue3PXR3HXcoc01gwh4bw9uBxNkrqU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ci7jh1HuchRLoNPTV8CCJm1sbc+LG+J1Etbt/o/WlYfVdrYRbuy+8DfGviw/seYI0fMRU4TAKzthoIsA+gV/B00dW4etoR6+XIwVwmkZnmW4ZeE78bS7Qn16BnKgDn4xGARpyO3SDcLpHvsYbv6cEceGmoC24U/p+2f3r7dbXDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IpfTZT6F; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e60966297fso2047572b6e.1;
        Sun, 27 Oct 2024 13:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730060180; x=1730664980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1szp9LKkxD/n7tHW53F2agK+dK5EsqpznWjYnTzGGAY=;
        b=IpfTZT6Fxl+Q7KiHlauboT9berswpZm322SVZpQL+jz/RBLxA5vLRsgRYF+bKzAI4d
         eJYCKDdjif2dEGNrzsPlYY38TjMoSR7bYUV+irbYaFX6wpjTaTcwce45i+2FHB6em7sF
         7BeAeyNUNSjB+TsNnsefdgZKw/wAn2oQ/vDQwm0omK8pAY82WT6R50wqgjjLQb3zuofq
         wjYxSEks2M5be7KviqXD+/5kJGXsOqYb2p6clD2d/z4U4E7Getlz00slyr4DYEaxiXS2
         WdVg4F5aSzpK2p/ovqKnAf/ABg8mPuk5a236bUIVPPD0PqDadAdci76+p9lJa3fpTc3N
         +bMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730060180; x=1730664980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1szp9LKkxD/n7tHW53F2agK+dK5EsqpznWjYnTzGGAY=;
        b=J4w/frrO0PypdBEl5hRLzIHFp0RS/LPuVwvWYBxRx8aHgNxWyC6+s71PKKkq5eQ/8Z
         JF5iZkdQtp0jVcWDBcz4+FfVzH1DkQ0ch14pbp0eHGPapf2yCd8W7TobXJ5c/JcmNbGY
         TIWI1r9Ly/KZJFYD0XFxRzJfcVnrU7Y5BFfzxqobC8Nxev1tY76e99g9qUciuWNQi3Ya
         ADdsxKGkwKBII/AIG8TNG12LU0J3r0mXOczbFtLUe4mrE6mard/zuafZB5X8Ear2TnBe
         8kfbHxT7ndbOqOUKyO32NsaAF7dwJC7AjFRsDdUkAgQorY2Jf4AufH13q2Z/87DkJ9u0
         iEFg==
X-Forwarded-Encrypted: i=1; AJvYcCW+LNDwnGZpQ/RLlHNZZ+skSuFn2RMSRegivzNYiAoYt7Epy3mwZpzuhkMnA/qanbNnNL6H/4FlLr9K@vger.kernel.org, AJvYcCWn7icarGSkBuBo/v+4v3r/uMMKviqcVMiVv8MH4+nhKEkUAmKhSApR+ivx18t/Pk0Yt3IX7GTtWpRhtuC2@vger.kernel.org
X-Gm-Message-State: AOJu0YxPCLogDABEiSzUbju4xbzfXkfOYUgsJMKgZm1ROypZGMtooO0r
	ebmpILW4/BOOJ2z4CZeyo0PIfjoSDeq7Q2oH4adC/3PnKlSdmATKecScTknfluS/wYLEJqm3biH
	YIGn2GellSIa0LHHZEjmHY53qlZ0=
X-Google-Smtp-Source: AGHT+IG1OQNQ0FJ+Z2qflN/6JfbUrc5rw7d6MF/HWc7iYM5zPWDzbKX7MVrgoWTuDAEvEOIllO/gV26tcc1t7FfQM7M=
X-Received: by 2002:a05:6870:d38a:b0:288:2b43:e0e3 with SMTP id
 586e51a60fabf-29051d49e8dmr4294239fac.35.1730060180110; Sun, 27 Oct 2024
 13:16:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006011956.373622-1-linux@treblig.org>
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 27 Oct 2024 21:16:08 +0100
Message-ID: <CAOi1vP8PaYSZCoWHkNFfSQyb2n0qc4pB7iJRrMpJ+9Ck9=UHdg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Ceph deadcoding
To: linux@treblig.org
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 6, 2024 at 3:19=E2=80=AFAM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> Hi,
>   This series is a set of deadcoding in fs/ceph and net/ceph.
> It's strictly function deletion so should have no change
> in behaviour.
>
> (get_maintainer was suggesting the netdev team as well
> as ceph? Is that correct???)

Hi David,

No, it's not correct.  It's probably caused by

F:    net/

entry in "NETWORKING [GENERAL]" section.  I don't recall
get_maintainer.pl doing that in the past, but I could be wrong.
Anyway, I'll send a patch to exclude net/ceph there.

Thanks,

                Ilya

