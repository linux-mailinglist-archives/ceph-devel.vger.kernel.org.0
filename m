Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CC02D5B5B
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Dec 2020 14:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbgLJNKx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Dec 2020 08:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389082AbgLJNKo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Dec 2020 08:10:44 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D7EC0613CF
        for <ceph-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:10:04 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 131so4013023pfb.9
        for <ceph-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sscuBKGZzy9Pz/UQvenJTRSzjBFg3R/i+D72jcogvqs=;
        b=Cv52YxIqo9avoL1GVAsFF9wWFNqYEU1loRZGdmuH1qUW2aYYYDGflwl4h1olQJRwqp
         jK73TTuGFnL+YR1rwbrjPpCH4DS3qN4Cc2lGt9CRISnfixNrvDEL4AuYdBNsOL6qNHiw
         57vx7EYVy6xub/zX4XGnwiIJ0WX8OPFZqOiAm728TwU2ogDdxxIsWKxoR3TfSwzdrLHo
         OJFuNpNoknOjcmEE8y/hftOS72AqqXGNLYR/3wkPXPj8Me4IDeprJj4QFShkWuAwmsYM
         uezMil5khbYxuLOGdyL3c+gNUxxV596AMKgYL21GcarsKcNhxoqL9jm6Rh5E2Gl2UQpt
         v2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sscuBKGZzy9Pz/UQvenJTRSzjBFg3R/i+D72jcogvqs=;
        b=OSGShiGv/Fwn8GfqF03cLNrFE7buGjzwb0hRu5GOaXJEaPOiX3wVZqub3A591inS2N
         Sj0UELxVZVLPNIetTEE0tj0Dpy9UPL9PBz9MtpF92AsT8fTR0BPDwoBvZUI2lDQvqRYQ
         6RYMkzs6xLuTH2v8j2G2ZFNcwJaRgMIbCFgLBnU6e5PGVISuSR2hK27sZ8QaJCe+exNv
         j6TMgqgm7xld/8NFT6b8dvmBNTHht30LsuzRJveZJ8wgwjNfeL9lFooiv5PIFnIs6OrZ
         munuwi7WfLM+v4U2JY23+/iSct1HtTzHH5Dy7S+32PQSauFf6khdAptygTY/EsTH2IzV
         4LyQ==
X-Gm-Message-State: AOAM531c+BwDI0cLBF6b0CNBuaJZr5yorky7czzt7GNUenXmIvX26tq+
        sybnP3Fj0j2SWCFHkuccj417xtMKX2f5+Jh89mwgurjojT/aBQ==
X-Google-Smtp-Source: ABdhPJzJZBrfVIoVkKJkPL7swlkeC9JSw0Z6TSRTvwhRDfR85HkCsY/sdZkqnZlzfF0j0bPjW6HZ210DfY1/26NNtaI=
X-Received: by 2002:a17:90a:ec10:: with SMTP id l16mr7718026pjy.127.1607605803962;
 Thu, 10 Dec 2020 05:10:03 -0800 (PST)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 10 Dec 2020 21:09:51 +0800
Message-ID: <CAPy+zYXDg4xFLiRE6e5iKZLokq2zSRNZrorPsbO68K=OW5SN8w@mail.gmail.com>
Subject: ceph rgw memleak?
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In my ceph version 14.2.5.ceph radosgw mem is high (4.6g use top
command).when I write 20m.
I noticed dump_mempools's buffer_anon is very high (3-4g)in
testing,after test,the buffer_anon has been release(about10m). but rgw
mem is still high(about 4.6g).So i think maybe some memleak occurred
in rgw.
Could someone can help me? or Could someone tell me how to tune rgw-memory?
