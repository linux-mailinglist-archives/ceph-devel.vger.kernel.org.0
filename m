Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C90D446787
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 18:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhKERJ7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 13:09:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20358 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhKERJ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 13:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636132039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=MQ6lmnnqMdPYuRFHd24SPkYh0+gRCCCxFQ3Es2v+F1A=;
        b=bDMdt0aX/12IcbYyFBW3iNWJA8fl4OLr2GQZxf5cVizvm+4/LKJ3nkDk8pFeLZsVwR03RM
        C19v2oetrpNVkEIvSxuuAeFxeseyTb7K1nCZogG7LJ2k6aOhjl0XVoWCazsif05759misb
        GkYTd/KnW5ZoPciC7xlA5vEyRLcXh1Y=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-kTKvn7dlOgKHLezo3EmmnQ-1; Fri, 05 Nov 2021 13:07:17 -0400
X-MC-Unique: kTKvn7dlOgKHLezo3EmmnQ-1
Received: by mail-pg1-f199.google.com with SMTP id e6-20020a637446000000b002993ba24bbaso6125940pgn.12
        for <ceph-devel@vger.kernel.org>; Fri, 05 Nov 2021 10:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=MQ6lmnnqMdPYuRFHd24SPkYh0+gRCCCxFQ3Es2v+F1A=;
        b=F/BFNCchtblNL+mtXPebdKtGioxPCmW7bXoqLX684rwtLyeaYDjQ6Wz0vMUnf6PuVx
         yCP1mXi98hwfmNnRY4pFMa23gqCycasP9Na4WuMW89fk1qZMSkh7ZcgteyATlFMRNXKD
         ogSpoAbVkgGMc1pzZ1BVwtG96VUbdvAiIIfuVEHROMytHEioXgjJgICyfwgFvPyLnTEn
         sYRsj6TGBfMww/pIFOfjkn52pvHAGYx1hdpQMc7ZkGszdpZVVBPaNZjDauNnGxzCcZGl
         4M/OmnWDSJM4TLoV/uQ8BRuIYxrfenc/hkbAx6fppFuMPYeWCzvwCSnG42rvT1jsYSmM
         xQCg==
X-Gm-Message-State: AOAM530yq3G01Y+PeH/suRT/4TBvL3fAKpGomZGVM7aC+69r4eJaLRvV
        y1/U4J/yNk/RgdcCHQ2QFjke24bVLsr6Nra1KVuJiP8SoZ5doWXeUIUCTxuJtL+CQ/0q3+/4ZbU
        Lw/qJUoy7MbvPGIvc2/zxWKt6im8+PVuCxYSZIw==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr31898634pjb.1.1636132036456;
        Fri, 05 Nov 2021 10:07:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQQZiwXjQOE3BGXFrsSwfVONK9Ncx5m4pWJ7pa5x43+2gKrfsDDAFlylaPmUZH1WqFUlwBUoaRSwzAvcOcaAk=
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr31898585pjb.1.1636132036039;
 Fri, 05 Nov 2021 10:07:16 -0700 (PDT)
MIME-Version: 1.0
From:   Mike Perez <thingee@redhat.com>
Date:   Fri, 5 Nov 2021 10:06:50 -0700
Message-ID: <CAFFUGJdht8P0K+vFLFbuGOYeW2SAUuPbHMw3OZ5vgqETZBPVfg@mail.gmail.com>
Subject: Cephalocon 2022 is official!
To:     Ceph Development <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello everyone!

I'm pleased to announce Cephalocon 2022 will be taking place April 5-7
in Portland, Oregon + Virtually!

The CFP is now open until December 10th, so don't delay! Registration
and sponsorship details will be available soon!

I am looking forward to seeing you all in person again soon!

https://ceph.io/en/community/events/2022/cephalocon-portland/

-- 
Mike Perez

