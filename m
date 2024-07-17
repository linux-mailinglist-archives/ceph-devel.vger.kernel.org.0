Return-Path: <ceph-devel+bounces-1534-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D68D9335F3
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jul 2024 06:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C3CFB22177
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jul 2024 04:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA8226FC7;
	Wed, 17 Jul 2024 04:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2U5hopi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04099524F
	for <ceph-devel@vger.kernel.org>; Wed, 17 Jul 2024 04:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721189197; cv=none; b=CAfuEd56HA+2ssQyINyKgUCnwr2CHCxxKkeFfWB0NqkgjTPRqxHAyweeuXTDrVIjoNqumYyzRczOZJ+8ka6GYjKJ5wDopL6hLguPFdB0VOVLHsx8O1g0uJNw6U43Ek/AX/pSl+JDR6TKjvBX9TMaTf4pmorSYuyX5a77OTL+bAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721189197; c=relaxed/simple;
	bh=7PE131J0FV5FElMlWrpl6/LssxXstkwmLuW/W14oPyk=;
	h=From:To:In-Reply-To:References:Subject:Message-ID:Date:
	 MIME-Version:Content-Type; b=VTYYESkjMia4vfGgd6BE7uQJ9qee988tFcZZEtqeeGHyZWOG5yqUkn4j8k2o/p8CdEHDQqTmHJ1NgqYVBLf60gSjV2HFnM6RbkgSfBKGydOf/gUAtytbED6zNrt+wU6H0y0/+N6N4rCBr2K8taJUxHWyv29k6eSETQ4aNHCmXgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2U5hopi; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c6661bca43so276341eaf.0
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jul 2024 21:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721189195; x=1721793995; darn=vger.kernel.org;
        h=mime-version:date:content-transfer-encoding:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PE131J0FV5FElMlWrpl6/LssxXstkwmLuW/W14oPyk=;
        b=J2U5hopicPk04HadMf4dNYA7dmXY17RZmXG3wrYDKYv9s6MV77y26RwUCX0DD2TrMK
         OXkSXdDqq6pmKObWb4y+yPlKwFowPLetK3oX8dWw+O9hgDMulLr0lj66i0UMR2aH86UI
         zyAmkI53tjID4ib+EWGKo1tNSsnWwkR3efu6Ql+Uvha+aBtxsgRQI0IMVX/uOGwI/l4b
         Z8UVGpm6gdcini7q7pDfC1T136n9i54ruZZtszz2gWN2nMlkPeY62sr4KvgJXAsb91fF
         8NvPlLdR3BirHACtZFsRjjQtVrduvmld7GsGPD9zrb1c0vxhfB2pdCw9zBTgCo08ditF
         J/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721189195; x=1721793995;
        h=mime-version:date:content-transfer-encoding:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7PE131J0FV5FElMlWrpl6/LssxXstkwmLuW/W14oPyk=;
        b=m0S7i+lwSWYFdOAX0DjtKqa4bryp5zLBAKjlUYRXzmfj+lStYk2/3yqummePD5/TQ2
         T393iu46PtieDkaAuJIQtceAIEZxCHuaXor5TdVHe+8rlRKu6xVcRKbolPoeD6xoGbDd
         ar/6x/m6cxpjx80HqbB+hUog760OG8CRAL9wPYiuSwyIxNC8uZ/85wv0JNA2pvc5hEyu
         22RwlbF3sscugLkQxa+ZBdKA0Z7OylK1IyKGc8WiTuudX9XhDeFsRSGep+OFUj6mRmtx
         qwuqxhyZqlcjglhZkpR5/AdhvfpJ1WSqEFqywyNsJvsWWA+KUZ2o1wjjM+t85mlyoHTY
         4QlQ==
X-Gm-Message-State: AOJu0YwWoQFiYm1Cf0OOJL3BkSzAEW4JnYcfTHVVgcu973ebkBHJQMyu
	+RObN4weYhLm2Av0LYCkpYJPl0T6I+cY+L6SkTLUW80j87fxHVRZM6E0Yw==
X-Google-Smtp-Source: AGHT+IFx7YrIGLU9TPQ0/UG7Xdih0KNpnw5VMDiMuNg53i8gXkfR5LYVVfqCzZ73rMMNc/DEPZb3zg==
X-Received: by 2002:a05:6820:c83:b0:5c4:6068:6ae4 with SMTP id 006d021491bc7-5d41d1ba997mr862850eaf.7.1721189194823;
        Tue, 16 Jul 2024 21:06:34 -0700 (PDT)
Received: from smtpclient.apple ([52.171.220.95])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5d3cc6b4fedsm169596eaf.39.2024.07.16.21.06.34
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jul 2024 21:06:34 -0700 (PDT)
X-Mailer: Apple Mail (2.3774.500.171.1.1)
From: Doris Wickstrom <depohinoelle@gmail.com>
To: ceph-devel@vger.kernel.org
In-Reply-To: <ddd89871-777a-6bb0-62d9-beb1074963f1@gmail.com>
References: <ddd89871-777a-6bb0-62d9-beb1074963f1@gmail.com>
Subject: Re: Enhance Ceph Storage Online Presence
Message-ID: <1195ec63-51c5-d10d-2b3e-ed36b301906d@gmail.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jul 2024 04:06:33 +0000
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi Hang,

I intended to follow up on my previous email about enhancing Ceph=
 Storage website. We believe it can greatly enhance your online presence.

Would you care to discuss this further?

Eagerly awaiting your response.

Best regards,
DorisOn Monday, Jul 15, 2024 at 4:42 AM depohinoelle@gmail.=
com wrote:
> Hi Hang, I hope this message finds you well. I'm delighted to =
advise you that we can assist in upgrading Ceph Storage website. Our goal =
is to enhance your online presence and help expand your business. Would you=
 like more information about our offerings and portfolio? Anticipating your=
 response. Best regards, Doris

