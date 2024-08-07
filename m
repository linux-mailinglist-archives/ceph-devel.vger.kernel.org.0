Return-Path: <ceph-devel+bounces-1638-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 157A694A340
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Aug 2024 10:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDEBCB216F7
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Aug 2024 08:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C051C9DD4;
	Wed,  7 Aug 2024 08:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBYmt/KJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D317F3A267
	for <ceph-devel@vger.kernel.org>; Wed,  7 Aug 2024 08:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723020361; cv=none; b=Bjr8KmGX2+6EF8zqwIelP1oJMZ9tGnKDyoKr3kqDO+d/P1LxVp9n+Vk5yFvt5SBq35SuBG2Hcj23ZOuu3EBU/mO3D8ZV1QAZHloJqggee5wAGpJwl4ZX2qn8r9f+E/uc8JPC/rQrUdtaMxHdj35Vcav4IjelexK5C2vsyTnLBrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723020361; c=relaxed/simple;
	bh=JIYCeV4uJlSo6zUb+VhPLW29iaO4GQB7NXb1N4DGxQU=;
	h=From:To:In-Reply-To:References:Subject:Message-ID:Date:
	 MIME-Version:Content-Type; b=JXNHKSawbAilAUMyIvZ8gj3LXcPAAwFwg2ylw3o6bN5DAamL1ZODw1gf0wZdgg3cVX6u++bEiuJYhuFeGoUVONDVh/CRag5r9W1s/9pIN5sWOt5lCbwNFqGpjCv+beoe4nrx9quAA76op0bgrSjliuznl2l0ZABcGsnv8Xl/8J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBYmt/KJ; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-6b78c3670d0so8827186d6.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Aug 2024 01:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723020358; x=1723625158; darn=vger.kernel.org;
        h=mime-version:date:content-transfer-encoding:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u1sL1RtDxHH3sdVCstkS8dJ4vmd28DZhKMS7GN8oGS0=;
        b=jBYmt/KJ29xqnShld7mcf2RJdMshp+6P48DEUvH5J8J0n1BMh03SsiFaY0qLiSZC/p
         4Sxw4qpHuLAx+2jdslxCtzzU2wAJ7sN6xcuC3oO+AQgorIV5NQzEJl6gaCCCCuEE0Dny
         cxOR5NsLhOJaxF35UZTfcSmRIJBjINwA/hgK/BmBmcOIfxiqBvFQXbfqqsduhamfhCZ4
         jOj+ZJb6ESICx6W9XeEowR167uzsE0kRnsurLX5wA0gHnYiSFE6av4FZuHqKhcG3kTbl
         rvaSShkkYpfhGdboyrExVRXGyTAZGiM+JJRWDPMCbVMOqDtSwr7/x/oVH0Spp0lv0qWH
         3H8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723020358; x=1723625158;
        h=mime-version:date:content-transfer-encoding:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1sL1RtDxHH3sdVCstkS8dJ4vmd28DZhKMS7GN8oGS0=;
        b=lYygt28SkLkH2XPK9/PIsM94BmTkiLk7RUTEpZhR0G0YEfBNBo1P1HeSLVVx0OfBpc
         Aakemn/TujRx/MaV50nqexEdJ2mZdwc2/oUJoU0s0WkJwjKZgDCEFDXSgHAUe3MCJUFf
         DL4ux1Q5MXr6WGoJtK0FvHXfoBGB8IGNRRUso+20t1YMw7sGqMkrBGbDNfCob3Dme7f9
         HWoqWlRyDP+m8MfG7LyDii6+6TpS2AkErUV3Sx8D0SmTaqQ0H50KjoYxaOvZqeS8QT97
         yQP9f5VZDXflwmndBktGrM26o4W9COBoMWGEtX829KiKv4zerbencrhYMwf0tKXSbjf4
         jqXg==
X-Gm-Message-State: AOJu0YzXPrTvnK5NFNNl2o5TbGK/GHLqFqD09aauHi4V/OHrJlgQICzy
	hZjqX6w8y4lJlWXtAtV0x9b5ZJwFvfKNkC5oFw4VIXm7Oa5UKOZAcrID3fAC
X-Google-Smtp-Source: AGHT+IEpFdf+wjgR/NiDQ2B4Pqg0guAKql2u9BwwolGL7P6R+Ep9lr0LMAbVUqHpnxOlWon7QCuq6A==
X-Received: by 2002:a05:6214:43c2:b0:6b0:86ab:feaf with SMTP id 6a1803df08f44-6bb98423a2fmr229486796d6.48.1723020358627;
        Wed, 07 Aug 2024 01:45:58 -0700 (PDT)
Received: from smtpclient.apple ([115.126.45.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c777e01sm54863326d6.1.2024.08.07.01.45.56
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 01:45:58 -0700 (PDT)
X-Mailer: Apple Mail (2.3774.500.171.1.1)
From: Doris Wickstrom <depohinoelle@gmail.com>
To: ceph-devel@vger.kernel.org
In-Reply-To: <1195ec63-51c5-d10d-2b3e-ed36b301906d@gmail.com>
References: <ddd89871-777a-6bb0-62d9-beb1074963f1@gmail.com>
 <1195ec63-51c5-d10d-2b3e-ed36b301906d@gmail.com>
Subject: Last Chance: Site Revamp in 2024
Message-ID: <50f459ed-b13b-e649-4b46-dbceae626678@gmail.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Aug 2024 08:45:51 +0000
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi Ceph Storage,

I wanted to follow up one last time regarding the =
potential site refresh for your business in 2024.

We=E2=80=99ve crafted =
many stunning websites and have received positive client feedback. Our =
sites are fast, mobile-responsive, and perform well on Google.

Would you like to see our portfolio and learn more?

Please let me know:


 * Yes: I'd love to see the portfolio and more info.
 * No: I'm not interested. Please do not email me again.
 *=20
  =20

PS: We offer design assurance. If you don=E2=80=99t like the design, you =
don=E2=80=99t pay.

Thanks,
DorisOn Wednesday, Jul 17, 2024 at 4:06 AM =
depohinoelle@gmail.com wrote:
> Hi Hang, I intended to follow up on my =
previous email about enhancing Ceph Storage website. We believe it can =
greatly enhance your online presence. Would you care to discuss this =
further? Eagerly awaiting your response. Best regards, DorisOn Monday, Jul =
15, 2024 at 4:42 AM depohinoelle@gmail.com wrote: > Hi Hang, I hope this =
message finds you well. I'm delighted to advise you that we can assist in =
upgrading Ceph Storage website. Our goal is to enhance your online presence=
 and help expand your business. Would you like more information about our =
offerings and portfolio? Anticipating your response. Best regards, Doris

