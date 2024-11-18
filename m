Return-Path: <ceph-devel+bounces-2157-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C4689D0ED5
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 11:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 133F528299D
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2024 10:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84358193416;
	Mon, 18 Nov 2024 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8RJLfN6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0517D17C98;
	Mon, 18 Nov 2024 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731926790; cv=none; b=R32qc++4hzf6h6N1nNoX/QV0UevNBLo231t5UYa/BF83cJgIiWGyMZzt/pSzSi17/N5D0M9/COJx1igpiYhlh/+aIuLyTrTm0/120XxAVfBBwepJjgCZn3lFg798c/mkBUVKcVln00Lx+ytH5kFTEjrW/hUdx1EMGllNOOgLvJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731926790; c=relaxed/simple;
	bh=aED80yudGW0igU3SJl/dBslp20DEnAHiQ93s0GOtHSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxv0mjgpdcQXIor7AU+c4SqSQCqVYgclrGlyQbPAcsltQ85qzuENs6d3JSeF/K12GCMphM0uHkKiEzKUkyh5WY+t8+glqHKxX33E78aI6Li8LhKdm33ioPXY8UAD9YPJVgAOP36LpvGk7pknToYj355XJdJ8YL37K6QH22+swJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8RJLfN6; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71ec997ad06so2871070b3a.3;
        Mon, 18 Nov 2024 02:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731926788; x=1732531588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ytf+pVhzpcwFlruK4lqpkOhiUSGxYFBVs1cSg8LhvyY=;
        b=l8RJLfN6wK3SEEysff3O8A6cVkK+GZEixSymAInrV/6s4WuANO9IXmLFpboAxjOyG1
         qNA8fwOywJzhfTGKNPZhRRnpIoWbSx/gZzcM21ngWz8sq+p6WrMLwr6EXstZtRNQ/slD
         DgImmASfJ0ZzjXn/8qOfb05nQ5aqJ2zb3W88TEKdmU4OfeMzhrHfdNEgXBki1PSl7t5H
         ifbYL37Jn3z4KHf7ps7g4zJL126TZ10j8TNFm8O6MVouU7hAVoJVWuNl7vEeXxXp3OqX
         SnyJ5mq+vny0qpT/G1RRpWI+NvNNzucMeXZWbdbqD1Q5+3Mn/rc3YRAEvyYzsX7Bgn/0
         2D8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731926788; x=1732531588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ytf+pVhzpcwFlruK4lqpkOhiUSGxYFBVs1cSg8LhvyY=;
        b=YhNR9PuqmlJdUZ7neQFjzq8a8YdU5DwWolF2RssMZjkgZnEgVWs6n+iyd4hrYW7aum
         PKlWlv3Y+XD4ZKXKkDIkf26pBh2mul/BST/mOPK/WVsMwH6O3P5y67Sf3wb9D/CXPdm3
         5ZD2oHAFvWKqhbobFOviNJE6DzruIm3z/AbnvFi8WbgemV1acDhVbfA1F8iua/BHeOJV
         BKiO7fxnZ/2m6DbjCy6nHZ8gWvZ9M0l2rybjQMSO/P0e+niJugirll6T0Hb5Sx8h+Bk0
         /5E0Xr858J7YVb+Nv9W0jV8WweTkrWKLwo/5VD5X06rwUCiDxUAJiXhIpDN0tlhVXIXE
         OiHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVe1p+k6sHRXjQE8xgc/IafR/H1qwQ3XOqkjMK+NHjBSgi1iWKaT34MMWd0lsSdLi8tjU506zMQ45tqQpsL@vger.kernel.org, AJvYcCWuHMQspRZHrjqy37z2TdMKxbsGoSQdh3kBb9/pxy8GoRMHIIfSYqLIgzL02kHWGmxIxCX1DTABtlay@vger.kernel.org
X-Gm-Message-State: AOJu0YypEro0Qedgio+C9JvUG6rGyTF6Jmj5D3iWLtuvQW27xC8C4vD4
	IugOOOHHvhyJqTXJ3b7tOgOmjxVjrZPJXhSVzMX8BHd/m/X3fnh4xI7FOl+ac7qAUdNerUl5+w7
	GYX1a3uMq51818xEe8S8c1GCgZH4=
X-Google-Smtp-Source: AGHT+IF/haTnFAafKYsshKczFn+0KFchhC4BBx3a40qLmENJb0ARvvg/LHWlg6Y7JdYj6qr68EepMkSKfOQvOwYgboo=
X-Received: by 2002:a17:90b:4b0a:b0:2ea:5054:6c44 with SMTP id
 98e67ed59e1d1-2ea505498a1mr6119567a91.31.1731926788264; Mon, 18 Nov 2024
 02:46:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014134625.700634-1-batrick@batbytes.com>
In-Reply-To: <20241014134625.700634-1-batrick@batbytes.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 18 Nov 2024 11:46:16 +0100
Message-ID: <CAOi1vP89tqvvb5SJW7h6L0SvtTbxfbxdg9tZp5FOqP=m7pwwYA@mail.gmail.com>
Subject: Re: [PATCH 0/2] ceph: use entity name from new device string
To: Patrick Donnelly <batrick@batbytes.com>
Cc: Xiubo Li <xiubli@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	"open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)" <ceph-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2024 at 3:46=E2=80=AFPM Patrick Donnelly <batrick@batbytes.=
com> wrote:
>
> From: Patrick Donnelly <pdonnell@redhat.com>
>
> Respinning this because the last series accidentally included patches fro=
m
> another set.
>
> Patrick Donnelly (2):
>   ceph: requalify some char pointers as const
>   ceph: extract entity name from device id

Hi Patrick,

Since the fix (the second patch) is marked for stable, I reordered
these so that the first patch which just tacks on const doesn't get in
the way when backporting the fix.

Thanks,

                Ilya

