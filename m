Return-Path: <ceph-devel+bounces-1982-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF279B1FE7
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 20:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63006281581
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 19:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89BFB16DEA9;
	Sun, 27 Oct 2024 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiz7hLPh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9904B286A1;
	Sun, 27 Oct 2024 19:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730058470; cv=none; b=K8NiN7FcrEPcF8AMI/bGPN6PhDrc+2Of5hvJMfRCFCSzrQMUHuFZm0iQwRPN9XZkC+islJBXjWPFZ+RXcBFl+5dr6DKCNQ+mqyzkzzcjHZG4jyzDTYV1RfqEYvE0WCPFJrVz9fkLYoPAs9DNpBWXG+i3uYy9HWLgrTlMxvI+BeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730058470; c=relaxed/simple;
	bh=gExQvMPbAjbTN1DrtN0YgCuBiyCwkZbz6UrpFd1T4mk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SOT3iAtZ55cqK3jj/DX5P2JbL7KhFXJewf3gbTx4hpCDX28PSwzKrJjk2wPt2ZyoLNK123GDc1BvYs0dDjAUcI3CconsIC2MTjcweo47mNNmEZzsgP2kBMz4GBdYU+eYSI1lErWLZN+BsK5qatyWWX+I9nQIhtrC39U8bBs5pZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fiz7hLPh; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3e5fb8a4e53so1899632b6e.1;
        Sun, 27 Oct 2024 12:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730058467; x=1730663267; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLHfzF7Vu+uG1bFL3de93K0nfmzXaKnCeT4VFxwzIuw=;
        b=fiz7hLPhM/vXzq9v5VibgPWkQVKQk6RU/aQsgi1hyl3Gx9BxgNJTJQLb7BtEkfiXK8
         dSkmB3jLY6l11HUA5zGMe2N4nX5K6vFbG7kQgEFbdRYGIn2Xmc65UEroXDJMxmGK7OFP
         uTjjoFfcY/Jd06YSv5NCL96+q0fXfZArbvVJlsx9nYmOCDVGfuN00voJC7DnHzedh0f2
         9qz2FHG0DDC/FjknHZV/BKKiSJOgSIfJXVC59fIII4vePcdHlK/BIXontaI5G2chXkAN
         D2J4sE1avyAo2C0R0Nwi9W0wQ/8X53f9Ltx51DBRlHWBG5Ttc52KRFR+TamJphCGEW4D
         xF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730058467; x=1730663267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GLHfzF7Vu+uG1bFL3de93K0nfmzXaKnCeT4VFxwzIuw=;
        b=emeDysM0aN+mXhWDqbyzkCRQmWeZqln1nBkSnLcAvkoFXBx4MY5RBsj31obxf1+FGF
         rVCVskMTwhT8GVCdQO0so4ClpFWfjldAbava3CtXu9bg3hlisq1BAU3lrGn+CpGB/Tpq
         +W3P7wUE9xRvgHXrgPYZjsZtDx+TKWY2cGS2szpezIlysLK6RSlYW5ZWg1EZiN8Y+Uhe
         YMd9007LLcIkQONFmFuBqchvPrU7aIIghyyHpS49HrFszC3pM0itxT+951ODlQG+WdIN
         ToPTDy+i2mnVQJS+XM/0+PGC7rLKhLNpZHzB/B7/hNDiXsPwFBKaHYo9e7gkohl2Rn9U
         QZ5g==
X-Forwarded-Encrypted: i=1; AJvYcCXKh6ulcKOr3WsbLm5GiFN6rD38+3nx0dHX4NN4J/d46O1pTyDB+NPB2Djbc1q3o+48XMUHk+3ZLDj13FIn@vger.kernel.org, AJvYcCXmFuX3sJ4a6qZJeD6OUCJ0dGncCSjtymUFoZFemmHGkZ1oymd5geM+55Iqlz4e0gr7HqqPrrGtrIOb@vger.kernel.org
X-Gm-Message-State: AOJu0YyGh/eTBaN+2PCXflg8R0CNQetr92QgKEk0OXXCtJzU0qol5z3C
	sgLiYJ2/SWiEdzriKYPZB5EKiQhabW4x4GiQeJBP+vh9yDsFTu/9GPvnuYbe9hNNUBwOkI7aZWf
	Udvl7erjflXrkWt5VlY1zaPZTFAM=
X-Google-Smtp-Source: AGHT+IFvNqQtA2qCnvFgInL4k2FnnkyZ/+9lFFs4WtoDc5wn+xO0yla6E0XsnoYZRJjDYauPJAM0Y4iv7sBOCRGeqM0=
X-Received: by 2002:a05:6808:3097:b0:3e5:fbdc:ba03 with SMTP id
 5614622812f47-3e63848a0d3mr3889116b6e.30.1730058467549; Sun, 27 Oct 2024
 12:47:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241014110304.60746-1-qianqiang.liu@163.com>
In-Reply-To: <20241014110304.60746-1-qianqiang.liu@163.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Sun, 27 Oct 2024 20:47:35 +0100
Message-ID: <CAOi1vP9hTZTEu7YsV=+J-_TncwKU2paBmFfCjUyB2G52o4qYyg@mail.gmail.com>
Subject: Re: [PATCH] ceph: return result directly from wait_for_completion_killable()
To: Qianqiang Liu <qianqiang.liu@163.com>
Cc: brauner@kernel.org, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2024 at 1:40=E2=80=AFPM Qianqiang Liu <qianqiang.liu@163.co=
m> wrote:
>
> Simplify the code by returning the result of
> wait_for_completion_killable() directly, instead of calling it
> separately and then returning 0.
>
> No functional changes are introduced, this is a simple refactor

Hi Qianqiang,

I don't think this statement is true.  If the wait is interrupted,
wait_for_completion_killable() returns -ERESTARTSYS and currently
ceph_lock_wait_for_completion() swallows it, similar to how -ERESTARTSYS
coming from ceph_mdsc_do_request() is ignored a few lines above.

Thanks,

                Ilya

