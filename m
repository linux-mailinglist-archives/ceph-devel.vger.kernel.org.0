Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63941A17
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jun 2019 03:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437068AbfFLBxB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Jun 2019 21:53:01 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:41909 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437016AbfFLBxA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Jun 2019 21:53:00 -0400
Received: by mail-lj1-f172.google.com with SMTP id s21so13607290lji.8
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jun 2019 18:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=m1bpZtXSyUaBM2QFxPxWa4OSk0urr4561kFH/KzClWA=;
        b=g+2q9gg9TVpVZSIpa5hS0av9ldDuGInqdrYlTgUTymfUdrHoQuCJ7MJDdaGrigE0st
         VOOUerLqsxDvnjLwzIvrQTN5Qe33ztQIJAw348dR7gmoD3kVXkhqTj1DliUH1ooGicGx
         RhmAlNZO8TW6RWD8hquckgcVVwUwao8pmULaHebq415qcv8PcbwzD75sazbIrkj4PYJH
         aDcoe9YVt0o+F2nMAbAMNW03tp5mcqT9zGBBwGJv7LWUmuzfr96R/IWcDrtiZZpUwTd3
         SLMpBlkJ6IAznM0xTCEDwhBOwSGYBRXuUQreh0Sikil5Cl/W1ZeLvBJwgp0UMEgOGLT1
         7lXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=m1bpZtXSyUaBM2QFxPxWa4OSk0urr4561kFH/KzClWA=;
        b=OjKNKWWFzf/xccwmvq7nsyp5eTzTFnnoRgFthKbbMm03pR38LMUw1AbuElsehhHhtX
         kdOsTpvuPDjs8zuueUJGyn5BSqgspLcezl4GERKU2jef5l8njiILAi/qaIbrb0+9tbuj
         gTjmkKHCCl6qfr66AlpFddeRb+qcbA4tXlfey3naoOs9CEvxPE5LlN32lblfWDoJb7JB
         NysvBZSiwht997gbIcTwdg3jr8bxzuD7UDH6oTM8lhxP8/RSk/Trz0N95nySYKpCZqwF
         L1zki93ePrgNRWZ4yOGzVv3u27nsExwc6t8DQk2eBS03hVBI/mtqDgyVMOgUN8TABsaK
         Sidw==
X-Gm-Message-State: APjAAAV/fO6K+tR4Fvg7tBRifYbfJE2ABDO4t4lFO6UJXpg6u66lG/An
        E8fjfFSjRFlfGpqUi6uCmom/+8wBzSrdQjWtBUQ=
X-Google-Smtp-Source: APXvYqzjDoYk9X6cwvT09/F6AZw4IdfLMEmczy3WIuqXzkPcXRLwLtIcc79bm/XUUklWAEnr5fDQGg7FbgzOpAhp6As=
X-Received: by 2002:a2e:f1a:: with SMTP id 26mr34938585ljp.37.1560304378696;
 Tue, 11 Jun 2019 18:52:58 -0700 (PDT)
MIME-Version: 1.0
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Wed, 12 Jun 2019 09:52:22 +0800
Message-ID: <CAJACTucBQKTh-NxM2M_=JbbczrfomR75W0y8xjHS3DPaqn9XaQ@mail.gmail.com>
Subject: Should client dirty caps flush be enclosed in rstat propagation operations?
To:     "Yan, Zheng" <ukernel@gmail.com>, pdonnell@redhat.com,
        Sage Weil <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, zheng and patrick.

During the last CDM, you mentioned that before doing rstat
propagation, client dirty caps should be forced to flush after taking
snapshots and before doing rstat propagation. Do you think that
forcing dirty caps flush should be enclosed in the rstat propagation
operation or be another stand-alone operation? Thanks:-)
