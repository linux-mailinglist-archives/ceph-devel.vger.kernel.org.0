Return-Path: <ceph-devel+bounces-186-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 323E67F88B1
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Nov 2023 07:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 694DD1C20BD2
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Nov 2023 06:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C2923D0;
	Sat, 25 Nov 2023 06:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpmVacAU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F8418E
	for <ceph-devel@vger.kernel.org>; Fri, 24 Nov 2023 22:51:25 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id 2adb3069b0e04-50baa1ca01cso233386e87.2
        for <ceph-devel@vger.kernel.org>; Fri, 24 Nov 2023 22:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700895083; x=1701499883; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MFJDXPn09SmarVBTYLOD0AwvTouX9vKjKYZTqWrf7xk=;
        b=cpmVacAUZnTJtttt9hCrRfwedmnhUSELZ4hqT4q/zDNsIV+HCsXwX6QLV+OerTib1h
         CQvqka9NFdVbrS2YoVxYPpCEo/VHtfOXQ47Ud5sa7s0o+3gk7TOMFi28tWH1nCligp/v
         HwNvzmZx84QqwCZRyWBQmlUuqcmNMq3zw+LxEqrTrGIf+dP8i+f3/QJQq4KUQDXLu/lc
         izza5DAYur11Cg0a5G4Oq+eNEhIHCHr0Oxdb1D/PYFsiTh24iYOl3bI7SOWQA/lUkqAz
         3OtEDX0Fo0wxrWodTTLtTV0mYmgYJmNGNeLzwQQuX+0wpv7GpP/1yApupnAJWQC1CLyD
         zvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700895083; x=1701499883;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MFJDXPn09SmarVBTYLOD0AwvTouX9vKjKYZTqWrf7xk=;
        b=pLgfC4nz89+bQQIMAtOGYvtaUSKORpdoa4bu5Hv6Rxq7POyMWHCuwuUvf00ZrUFA/r
         bw+2fkgpBjNeJF3Gvn2XS7r33elCSvpxi/VR+LMH2vRDuGVF1lENdn74vQyiF3zxx3Rt
         yvX/zp5R1EF9Hj7AyU2RyM9axaRD1tVi8RycdQSBTFUJBXKGhCWDU0F8C9QDSAhhE+Hz
         gZHHOaQK6Li1/z86Kw4MXBd5j3l4V2JuJZdyNS3dnqBW0J2PH+B2uFp3q7cAkB4Ac4Au
         Xp7BhoyMf852CVBXa8KpkYGI5BvwA/YEOcgns8D2+VgJ4Fw1yPYO6sVGgIvC+4IvbTXK
         fa6w==
X-Gm-Message-State: AOJu0Yzgd5ABLBSe3oqSr8ce1lsoffE7hj+UFOgj2MNmXCPcKxD+m5Z1
	egzN63iW8Ky7jjWyUpbKwI9AhLDDEX8FodhArxhhssBSRcHYKnYq0P8=
X-Google-Smtp-Source: AGHT+IFmMEQDLGNmtcisngy4VLs8JCuNeWD2uHofdnrn9m9OrJj9vA0JaSAQ1js8Se/aQtOgHRNwGLPLJGtkDxH2BbI=
X-Received: by 2002:a05:6512:3f0a:b0:507:b1f8:7895 with SMTP id
 y10-20020a0565123f0a00b00507b1f87895mr453294lfa.38.1700895083485; Fri, 24 Nov
 2023 22:51:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a05:6022:829d:b0:49:dedd:69c4 with HTTP; Fri, 24 Nov 2023
 22:51:23 -0800 (PST)
From: Michel Magnett <magnettmichel08@gmail.com>
Date: Sat, 25 Nov 2023 09:51:23 +0300
Message-ID: <CABBXkWcad8SMV90ARboY5vdWxmdukjmBQniq4giCvJ63NyDvOA@mail.gmail.com>
Subject: Hey love, missing our late-night talks.
To: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: *

What do you think of these pictures of my chest?
https://qmai.us21.list-manage.com/track/click?u=be36685207cdd9957c655a505&id=363476a062&e=1d691756ea

