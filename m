Return-Path: <ceph-devel+bounces-1529-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF670930D5C
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jul 2024 06:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD03281446
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jul 2024 04:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E3A61FFC;
	Mon, 15 Jul 2024 04:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxgKFhjb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D64500D
	for <ceph-devel@vger.kernel.org>; Mon, 15 Jul 2024 04:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018559; cv=none; b=QAPKQdeCGJPaXHhBc8xMaU3ZR0r2kPsydO87IJpow+jL4b+XReuWzCuUc1B0Lv1QkQRFiPYh1xqhfq95q5iqs9c4w/WHTp+kxooT1KxU/9+8qb5aNzw2XwRSXoU+/+2JXSKOwasl+aHgJfxJEPa/r8Xyb8EFm1YDYwYR8Cd/AJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018559; c=relaxed/simple;
	bh=AT+9KMpVh5oVL0Psyn32LrHxbNQmR6nilPyKt3inYxU=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type; b=FZslyh4JINPtDijlG84zXF4ZQYeCFAbvdYf547Dmc9ICY1yaz4B7Yhr5T3j2FSWTypdh+CI8EUQU+FKiEnK4arve6DowbJFIbuPe7PnbMyP+RDK35XK5p1HB03S9g8xVd6a0u0TK39RkKlIuQ7jsiMOgK6JHITNuWq8G4q6+5co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxgKFhjb; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7044bda722fso2349788a34.2
        for <ceph-devel@vger.kernel.org>; Sun, 14 Jul 2024 21:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721018557; x=1721623357; darn=vger.kernel.org;
        h=mime-version:date:content-transfer-encoding:message-id:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=AT+9KMpVh5oVL0Psyn32LrHxbNQmR6nilPyKt3inYxU=;
        b=fxgKFhjb7pMrtmltXp0VksXzoiz1mJWlPbAs+k7TtNIjDRQBgnAw2HrgD8xe5sYcqx
         AErUKl+jDzXVCh7mIK2eU/d8ZqYLtbtgx0qjbF5oyEJkDJBLYr7r9EejHTS9nGcpEDzm
         /JtA5ndhjDRrakBs6ytzG8Yh6sqWyD/WZWGOfQK7nqTWUXLUzICGKtxqapC5V4ilVNev
         BircTlxdUsNrmGOJwEWb2SFo1tX1JsE6xl/1Akklsya4GDE5bSe1puYpkv8azXYSkUI5
         6dMJ8iXSOOFG/B9Tdi0uasQERdswFDMfXBXXMT2EQfpzTfTIRIIb1EJMAkGyeKh7xlnO
         +3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721018557; x=1721623357;
        h=mime-version:date:content-transfer-encoding:message-id:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AT+9KMpVh5oVL0Psyn32LrHxbNQmR6nilPyKt3inYxU=;
        b=UcOlnnXfy6sCQHIZGtfMtAwEYwDsXoIK2r/Nm89/4Ao5a+U4pH/dtBxIOCAyMuC1gV
         7DzjoU6FRS637nb2o4g7iYKp3X4MIPvQzrDRHavIBm/1QtV7drsDBl6eC9eXKvmm/j+K
         mFfTIvjNjDHIg7iUN8fVRbkOL8U/6MxjLbljyI1s55/X62WIf9ZZqSEyLt4N7nV45mTR
         MXB3aP4UyfY5cvdwZj5uxk93Q62wBKg7XU/VAZl04XMb/ZcEcSjY31yx3OfXvYb8VS+h
         RTeiRfMLGJjYCOHybiBAQ0woJXDcdwH8UGd1Ne9eeAuAfmjC8lT7HqTEIRwjeFnxSGQk
         L0/Q==
X-Gm-Message-State: AOJu0Yy6cpFms8Bt07US+IY8GdkVMwz3rCgE6XSZtmpy0a8y2A5sVmrD
	hIu0vwT2LI2Snh2Ofu08SFQutLTfRGVvpPhJvUtSPUWhVIx+Q2ajprULpg==
X-Google-Smtp-Source: AGHT+IHRgdHsgr0tux99lf9c4K+VI6UVatXBnH8OIli0um6eYKtFN7IhYfg3hPdJ7DxXpq/2iAkrCg==
X-Received: by 2002:a05:6870:f150:b0:25d:fd27:9093 with SMTP id 586e51a60fabf-25eaec63317mr13849149fac.55.1721018557128;
        Sun, 14 Jul 2024 21:42:37 -0700 (PDT)
Received: from smtpclient.apple ([52.183.208.60])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-260752a9036sm843454fac.38.2024.07.14.21.42.36
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 21:42:36 -0700 (PDT)
X-Mailer: Apple Mail (2.3774.500.171.1.1)
From: Doris Wickstrom <depohinoelle@gmail.com>
To: ceph-devel@vger.kernel.org
Subject: =?UTF-8?Q?Take_=5BCompany_Name=5D=E2=80=99s_Websit?=
 =?UTF-8?Q?e_to_the_Next_Level?=
Message-ID: <ddd89871-777a-6bb0-62d9-beb1074963f1@gmail.com>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jul 2024 04:42:36 +0000
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi Hang,

I hope this message finds you well. I'm delighted to advise you =
that we can assist in upgrading Ceph Storage website. Our goal is to =
enhance your online presence and help expand your business.

Would you like more information about our offerings and portfolio?

Anticipating your response.

Best regards,
Doris

