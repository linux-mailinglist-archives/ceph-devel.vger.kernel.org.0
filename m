Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B433F1834
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 13:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbhHSLbD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 07:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhHSLbC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Aug 2021 07:31:02 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0268C061575
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 04:30:26 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso3262164otp.1
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 04:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=h3aZTrCb62DNYhpJGTvZ4Kku5N7BEorxuPyN/PlVL+8=;
        b=mA9pHrRhsLlTn34qFWzZ72FBLqJ5P2pEKkk5Q5HEF6HlLVzaGmle2f6PktDXtT3cfw
         yKd1PXxp7e+qmrUPU2CS8hyqJMSEJKOHkC5lOgTTsMnER1YJMJU7ZxbGiRExbvd+QVir
         FPeLVmbdqu97ue49h8OK8xW3lXDh677aRxDf3EG8z27am1tqLxFXUNM0PQ8jimyotYGX
         D0/DpcV5ZYF5G5oTgWHfxJvUKMvnxpWUS6GP4DPO19oJ5/ACLVuCfm9NB8EYpErIPky7
         /tGZ4R09BdJyAHIh1X1EEEaJJJjMWwC6TDG6DXlzPIpIUi44mJHakKQM3R10tTNiJCsu
         vF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=h3aZTrCb62DNYhpJGTvZ4Kku5N7BEorxuPyN/PlVL+8=;
        b=TPh4/3jfsdG3Vz+0B0mn6EDMmZBy1PjXuEgRO4hL8WOBJ3vM6XmVHmme1qaXFn8CRr
         SkLM6ndu2HGSXj65pIO8xRYOsDuAFf4hhd2EkEFbANxMyCNqkJdHWzqnT+ajqITpTX5K
         ybtpvthlgjaaDtHwdqVndxieru/iqBqKl7YqYdeY8gYKyjGsux9fuIoVzhIuJkLkjXU+
         thQnYQU1bqS0LzsWDuvU2caer6Crz4rnjbCVHGPHBnUf4L1mxOaiHwckUWm1B1M0uTRm
         IbRpmo8Naxl5T3ITWwueiL+FypG4UVIDwuUtgDY7jWYbOxFHJu15TJC+AR83i8JgjhKF
         P+Dw==
X-Gm-Message-State: AOAM533TIzW8WFFReKGQxZY0M3YzCbbTQfbpW6Mr2YMs7Yxa5Ut21W/o
        LtGpYQ5Mgo9+dxWuPsQZgKsnquIb00ir/qCVm5A=
X-Google-Smtp-Source: ABdhPJwCQfc+gXNtOFw5PTbQskYFrBxiBE0Q+bPMcy8sXQ0WBVo/VIWCn6/1C9jcPaYNQgusF7fWA0STTN4FAMAYkfw=
X-Received: by 2002:a9d:1ae:: with SMTP id e43mr11934695ote.26.1629372626107;
 Thu, 19 Aug 2021 04:30:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:9f54:0:0:0:0:0 with HTTP; Thu, 19 Aug 2021 04:30:25
 -0700 (PDT)
Reply-To: manuelfranco4love@gmail.com
From:   "HARUNA S. ABUBAKAR" <sabubakarharuna@gmail.com>
Date:   Thu, 19 Aug 2021 04:30:25 -0700
Message-ID: <CAOsshUXArkv-QUdV_V=KS9U4iiz59GhjYD081zT5PSEnM9f++Q@mail.gmail.com>
Subject: Der Betrag von 500.000,00 Euro wurde Ihnen gespendet. Kontakt: manuelfranco4love@gmail.com
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ich bin Manuel Franco und habe am 5th. June 2021 den Power Ball
Jackpot im Wert von 758,7 Millionen Dollar gewonnen. Ich gew=C3=A4hre 5
Personen jeweils 500.000,00 Euro und Sie geh=C3=B6ren zu den 5 gl=C3=BCckli=
chen
Gewinnern, die ausgew=C3=A4hlt wurden, um meine Spende von 500.000,00 Euro
zu erhalten.

Kontaktieren Sie mich f=C3=BCr weitere Informationen unter:
manuelfranco4love@gmail.com
