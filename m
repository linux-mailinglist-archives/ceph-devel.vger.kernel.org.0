Return-Path: <ceph-devel+bounces-259-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF538096F7
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 01:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CC231C20C55
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Dec 2023 00:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C8880A;
	Fri,  8 Dec 2023 00:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j72CDIBZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AEA1713
	for <ceph-devel@vger.kernel.org>; Thu,  7 Dec 2023 16:13:55 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id 38308e7fff4ca-2cb20c82a79so2775091fa.3
        for <ceph-devel@vger.kernel.org>; Thu, 07 Dec 2023 16:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701994433; x=1702599233; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H/ME+NbEdor3fQzMEYaSkx6H2CZ19OKLVk6aF/NB2+E=;
        b=j72CDIBZ6IK3xGy2wqNqF3cBp+pvHXkJE0ZRJdHmrOQAL0Uz1tQDBmS5dH2HOChxpu
         3ffpmUSPxWnihvaGQjlg8SMGU6HzjojiLgNXww0FfMe4jWN3v/zE6iWGQ3YsCJ1PKaQB
         hGAUJfNIqlvmpNe4nHZp4t4NS+SXNiegOqTCFnEPH3F+bCEs3ESI2xF6GfP6KjMjy5IU
         F6y/xIMuggok2+/J8zvTzfYaRqKthzfSVtmaCETq6xpf+WOdmzTlizhDhkhRXLVtDjjd
         Qpc3+eqV1+3b9JQJ8j1zwcO9VzT6sxUxTZ4GQJnHaWLPALrdh+ayybsFv3zvUrLJs7AU
         9uHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701994433; x=1702599233;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H/ME+NbEdor3fQzMEYaSkx6H2CZ19OKLVk6aF/NB2+E=;
        b=i7VwhB9L31wljgALs2I7Diz+uKAoqmYaoXZQR+WsrWYF27ELovtzxja7mUDClb8wUj
         brkWlXtFr3AKtpi5dmX58T0PjX2V/Ius27e+GrhKImjsb86LL1Dpvz6gyVCOFmHfX+0M
         f7jUNpy1KYcKsWKzzKrKfyRcju2SmInVwHaw/2Rr2I0dWMLxdE5ppAkqebe5Wc7z0jfX
         V8vh8Dj5Z6GgJ5aHLqSvToqJk4cjXph0c/cDQnI2FQS8W01S9vzw2D2J3PedPx+yBLK6
         GDV+oz4byfandAKgnyBlvFweqj3EO6DbFnPc060Zd27zcgNuaNlTGsuM+Y/lMme4lsVX
         khng==
X-Gm-Message-State: AOJu0YxIKw2Fqvq1UmBN/8argXkbDo48drcs0Aek/oJ/Xv0eqQUfCG4I
	AtDB6DDORBFhaSM4INWV+IvgcKNwpZNw/Cn07njELdNz1rBLmiyIWSBs8Q==
X-Google-Smtp-Source: AGHT+IHzF4MWBLkMxHT/u/7v5ifZ4jbxCZNgnDmVdMmMZpfwrf3o/wexOJ+mIQ5MXRlpYu/TTqbYjjRAKgL+7ljRtiU=
X-Received: by 2002:a2e:8416:0:b0:2ca:16d2:d0a3 with SMTP id
 z22-20020a2e8416000000b002ca16d2d0a3mr1810886ljg.69.1701994433265; Thu, 07
 Dec 2023 16:13:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a2e:980b:0:b0:2c5:1d95:f7a3 with HTTP; Thu, 7 Dec 2023
 16:13:52 -0800 (PST)
From: Birgitte Batty <jepuzoti@gmail.com>
Date: Fri, 8 Dec 2023 03:13:52 +0300
Message-ID: <CAJ31exGms9i4FXKqOYf8c9VNY5k1JLm3E-4U5otJJgsyVZA+fQ@mail.gmail.com>
Subject: Court Order: Directed Financial Directives
To: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: *

We wish to notify you about a recent court verdict that could
influence your financial status.
This order is solely connected to an individualized case -
JD-P1Q8R3S5T7U0:
https://qtnp.us21.list-manage.com/track/click?u=c019ce2ced9d9c49756fb7da7&id=21b55f31be&e=398702c985
It itemizes exact financial limitations that are now applicable.
Your immediate focus on this significant matter is highly appreciated.

Best regards, Chief Communications Officer

Harley Loreg

