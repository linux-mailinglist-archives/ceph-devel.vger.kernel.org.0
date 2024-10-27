Return-Path: <ceph-devel+bounces-1983-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC26D9B1FF7
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 20:53:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7292F28155E
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 19:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A410A17B433;
	Sun, 27 Oct 2024 19:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQxMjf4C"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D8D286A1;
	Sun, 27 Oct 2024 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730058797; cv=none; b=B4IYhrjJrqwTeT58zimQYXddsAfzrm0s3xvKhaL8UT7E2lVP/ZcqxvM0PEYcNhAR/dKYmOq2rzjGnk9O85DTs4gcBXYkgExWEy7K3rcKrYsK+7lwitQlSr1lScLay4YEoBCdtaL9wBs6BTbwN3YYAqoEZ4Mdelpmz8SIo2E3jwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730058797; c=relaxed/simple;
	bh=c2OcbVFjFuUi7hi0qa0JMn5XlXvwQdQmqgxCiMBr8QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAtEDxjThAOFwLMh6mTwtcz4LmEwaKT+zks+8ON3QixnznpcSG1V/W9tIZ+coa1pN+nTezufwwriz41immInUUE29TNZSTg5RXcZldLeNrQl6ECySgnE9dF1Pp4G7OqnEO9wbWyfa5v3QrpUqX/QIyQo1oT2zcH39qhVEdDmAto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQxMjf4C; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-288c7567f5dso1792193fac.1;
        Sun, 27 Oct 2024 12:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730058795; x=1730663595; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kpZwKtoPENRDM58Vhybc2mG/ybYD9EOEy2sbkHhuTBE=;
        b=PQxMjf4CBVKCvm28Dy4QeLI0pwhyFU4Zo2FLVl8mEkap4jnSRyb/Za0oOPMPHWqumO
         ii02liZst22tTDLH4e77itwvYpBGiRV0SOCaB1i8bplRt0p2ioSIgvsnjtE19OPijvlc
         UosQpnFKO2ESMZ156dLTYYnypfwL/RIo8uO26gJvantxLsmfWZskZ/fF815tUXY5IuXo
         U4AfG4Qv8ifDrCtf0MerFnHQIYmY0dC7jJOc587w3uY4i58UH+/QoX5HsXsSX7RzJFgE
         Y4AprutHyPHTuGZUZEKjxcOdk2atJoxOBdVqq3w28EuDdIOxb2iL2/yYRwZhsqk6MFPr
         dU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730058795; x=1730663595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kpZwKtoPENRDM58Vhybc2mG/ybYD9EOEy2sbkHhuTBE=;
        b=uuWJxrQrfW5gQASo1Qcw6GamUN0gyo2Waah2rwjP0pxMqWeDMeHb8CON8erchpNapS
         HzsRAg9v6dZFv9qwSvG/kx1KC4d4CYdFEiDB/Iiwv+5Bniaraym4Nka98+eND5NQnM2f
         ykAvT+o9Vwt7uni/7SBnTvqlvnFKNCvsnkBGRrIymrF7zYLBWi7I+KbH837Qmw8/7x90
         03uNrNWtYXpMhiTcX0g2+N9ORf0oWC6so8mRJBF4CURRUzD1Z03gU+UaHD907nDti6IX
         vBWbdCl6mSodsivrktUDAR0lVG0hXChyIIJVm4xSWQNOvjg06O8JC7S9RXrsAl1PiFvh
         q95w==
X-Forwarded-Encrypted: i=1; AJvYcCUzMEeE0WrS7qYWFohOouDHpZXqJ7fpt5u1J7lTcDih3QSNUOQZfVrrNnOc3lXHAempFUgb7zkN3N+ASVBL@vger.kernel.org, AJvYcCVcMikjV7P3XQI7jMDWijDTXS1tb+PhGs4MIoe1rPjXT0JrpvzkdvpDg7Z/wgGrXs1dwCQwluoh2uoD@vger.kernel.org
X-Gm-Message-State: AOJu0Yywpjq2yBSOchMu5Y13ERrAVoWj7Vr3AsJjMIVx/veDcgOvrSRR
	sMo6fO5n1EbmZVs/cUq3tQ8i0oMN4ieNUROXIv/jymVC1ZhLQENjWtzu4DhftU/AcAwpfdukR8M
	/kTE5gZpBm+x9kbDhLGnI9MvKuBQ=
X-Google-Smtp-Source: AGHT+IE/0ePnsx2a4in0XRQPmNmJb+zbu6jJdlqSpWh4ING4cZKG5GvITNdeWwvcYiSe6FM8GdWvRgLp9BuHWZ76oMQ=
X-Received: by 2002:a05:6870:8a0c:b0:27b:5a02:f940 with SMTP id
 586e51a60fabf-29051bc479fmr4347534fac.23.1730058794633; Sun, 27 Oct 2024
 12:53:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006011956.373622-1-linux@treblig.org>
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 27 Oct 2024 20:53:03 +0100
Message-ID: <CAOi1vP8bCkkeVCpT4Y8shSyMgq3FxN6eFawD8_pTnpA0a6PTzQ@mail.gmail.com>
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
>
> Build & boot tested on x86-64.
>
> Dave
>
> Dr. David Alan Gilbert (5):
>   libceph: Remove unused ceph_pagelist functions
>   libceph: Remove unused pagevec functions
>   libceph: Remove unused ceph_osdc_watch_check
>   libceph: Remove unused ceph_crypto_key_encode
>   ceph: Remove fs/ceph deadcode
>
>  fs/ceph/caps.c                  | 14 ---------
>  fs/ceph/mds_client.c            |  8 -----
>  fs/ceph/mds_client.h            |  2 --
>  fs/ceph/super.h                 |  1 -
>  include/linux/ceph/libceph.h    |  6 ----
>  include/linux/ceph/osd_client.h |  2 --
>  include/linux/ceph/pagelist.h   | 12 --------
>  net/ceph/crypto.c               | 12 --------
>  net/ceph/crypto.h               |  1 -
>  net/ceph/osd_client.c           | 34 ---------------------
>  net/ceph/pagelist.c             | 38 ------------------------
>  net/ceph/pagevec.c              | 52 ---------------------------------
>  12 files changed, 182 deletions(-)

Applied.

Thanks,

                Ilya

