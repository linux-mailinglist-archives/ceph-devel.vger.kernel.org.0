Return-Path: <ceph-devel+bounces-3664-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C668B81CB9
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 005D77AA75D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C1CF24395C;
	Wed, 17 Sep 2025 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rf6BtZd5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C17234BA30
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141578; cv=none; b=fPyzRZgda58k+RQ9+AxJNCX+kYioI5ZXb7gEzbXh0M82WPRpZWT5UJEmG58y3lfFTEm2ng69TzyVnx5347YmJQ21RNdnHn+aCvRA3rVSXjWvA28aPzzuVkqITbXxicOsS/4oVjNkqtPsWvDVY0qqM1JoOAiVnJgskmtS1pUMyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141578; c=relaxed/simple;
	bh=BebIfPKMuviYRuRYSLWRfv2JJQg0blZwV/yFP6rqZes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RErvnYOrXqBOnk63pFbZUMMDaH1muiD8ez9uHWRlHuaUhMJhlO/cPNZAtWSZ4PYotoMTH8F3eD4z/9llieepSm7teQSlzD5UB24KtyIA9dtjISFAVQrwYTlRSZZfLYsq63suE6zU5MYwYlD1XOQMJmp7jvPs0Ew2jX7xG5kT2n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rf6BtZd5; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b04ba3de760so30789566b.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758141575; x=1758746375; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2kzkQ4aOmc8N9K5jIReO5F0CstRjbfQHaSb2cVdK+0=;
        b=Rf6BtZd5px5DWAIkVIE9JOgUV/0HNpaeamtT0X0mALWjo99TurpXoMdIgbbOvCKctP
         RjNiEdUnPfFaY6wePSf37AxssgfZtXpGBuIlvy8buKj4TdCcGIGv7wdBPCSCnozZ3vck
         lRptCX3XMLus2nriTHhhMwv6GWWp0DyZv3TPmHqm839XLtputx2MPCx6iP81SDmYIrg5
         1aHwPfD4AqH+vloPmjtX0qP8m2aIXY1/hzS9aXIBerfAzgWDKOD7vI/azpH8sZMXxwi5
         nhGWyyAQasRVDu4xelsR4aQhAm2OUVJ5jCpYt4HanPcYSjuQ/oAhBE8wy0yOwbH1m++f
         Feww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141575; x=1758746375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2kzkQ4aOmc8N9K5jIReO5F0CstRjbfQHaSb2cVdK+0=;
        b=lM5QSIXJL3J6IEEZh48m0RBDW3As6SunLZNQ7OyDBMkIZtuVkBo/s/3MzHPt/QXSSl
         5s8oC5X0FEPXfQ74fsEEIrTmBoqZeFiqoVcH7ZVLK32fPu2vyfIaJZBZD3j9+RsrggcM
         xmiYLq3rjr1567LzocAJi34ykrnkKETk0ZBA+i66zkVRMiO7ovXFSuDbvkTuVYY+Eepd
         iqSUg3I715Q4Dt81TmmWJXpUlaspFUEbm80RaPDDS1PbdmYY9XrTC/splCky8whFnqyJ
         /hNB+iVq1muGyJVmXGRjwXCPdjf620XTKRR7RQ0ZXY6+r7ftIQI+rlmkCI7T4oAmaGs1
         9Chw==
X-Forwarded-Encrypted: i=1; AJvYcCU2kPkYIjyXBFhUAeVszrtpz+7FHVSsyBJNdsLPS6Elu2WBp5xflq2nf2sFufH0GzKfg9F0WYfpEeBG@vger.kernel.org
X-Gm-Message-State: AOJu0YwmYh2ryE/UOac/UhjlPtY7sAxj/TgrS/S6hJBki0Q4pnUa8xxK
	CcbIBkGV4u7QBQrfyKMvoeYDq9GJ8192hfrUnyIelEdV3SWJK7AYv/I/wIcAsjg7jcXuLVFypr7
	eF3MwNN7HfQv5gYWUZ+cyrDCupgKVSbY4VwqR
X-Gm-Gg: ASbGncsRresLULEOHaw+xRmreqEoUVc07HaU4i19gH4ucaO7DSlhHzr1suXRLZq8hKW
	+p/se5uleYZxt2Z2EkTy/FEnp3J30Y4OaHY4zrR0yROB0p/crvUK3OGSvSEgbX3nfJxTvUAGaYW
	qXFxGRtHHkP2YWUpXPBtsNxTBHbg3tMM+5DRYm0qNymwM04A2ZhEnlowqKOvCqrdJeZGQIIS1mO
	LmesevgZ40PmFKChh+2H8QD7HUrJZodExpTcro=
X-Google-Smtp-Source: AGHT+IFrI9fhyiOasqs7aFU5vuu3zzSapgEYvzTIhik4QC4sPMRAXmiqTqntHyu9WssGZGcjsazcwAN0AhwUJFXW33A=
X-Received: by 2002:a17:907:6d11:b0:b07:cf04:8a43 with SMTP id
 a640c23a62f3a-b1bb7d41abemr393772266b.41.1758141574464; Wed, 17 Sep 2025
 13:39:34 -0700 (PDT)
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
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 22:39:22 +0200
X-Gm-Features: AS18NWAETzz-YcBQYRqakGPsgrcnxDdpvhBGhjX9-5GcpAybEJQMsj_xDszE9Ik
Message-ID: <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:34=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:23:00PM +0200, Mateusz Guzik wrote:
>
> > This should be equivalent to some random piece of code holding onto a
> > reference for a time.
>
> As in "Busy inodes after unmount"?
>

Where I'm from (the BSD land) vnodes (the "inode" equivalent) are the
base object if you will.

If there are busy inodes and you want to unmount, it fails. If you
force an unmount, there is some shenanigans, but it ultimately waits
for inodes to disappear.

Linux has to have something of the sort for dentries, otherwise the
current fput stuff would not be safe. I find it surprising to learn
inodes are treated differently.

> > I would expect whatever unmount/other teardown would proceed after it
> > gets rid of it.
>
> Gets rid of it how, exactly?
>

In this context I mean whatever code holding onto it stopped.

> > Although for the queue at hand something can force flush it.
>
> Suppose two threads do umount() on two different filesystems.  The first
> one to flush picks *everything* you've delayed and starts handling that.
> The second sees nothing to do and proceeds to taking the filesystem
> it's unmounting apart, right under the nose of the first thread doing
> work on both filesystems...

Per the above, the assumption was unmount would stall waiting for
these inodes to get processed.

