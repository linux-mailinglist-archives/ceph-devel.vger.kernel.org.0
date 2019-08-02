Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A034D7FEA3
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2019 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbfHBQeE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Aug 2019 12:34:04 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:42276 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfHBQeD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Aug 2019 12:34:03 -0400
Received: by mail-yb1-f171.google.com with SMTP id e11so665511ybq.9
        for <ceph-devel@vger.kernel.org>; Fri, 02 Aug 2019 09:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=tJDwHKS72nJQ27kj3sYn5mK3Vbjn5D5bteG0rxch45Q=;
        b=WrPlxlL20v4EkJi3zGBZZGsY0EbCvhu3lzTOgk6yJOp8YvQmqqWmLrwWIB4lY1u+qn
         UF4Ff+Lf7j8OxtZaFvNtyP1k3f/GQ7tyB31U5lAqDoiOaC3BOXiCwIwht5Tg86s5/F6Q
         rmpkLnpIZkD3bWxT+NMJ8BK3AJI3nl6ANNBh9n1p43qFZdCncEAK+LwLSoVs7ZLqmTPT
         QrgYRlxpdB1lvlIQyPjRPHIicEwenolYcA9rrXVZXjQIxT6LVc7HsP3fk58fKUFGHswI
         yHm+wPx12a/RGHSn3cWRa12LP1AOWbFyqmTsfw1sKVnm0iIoqdHfCmtHbKJTyq+JHLHg
         1eKA==
X-Gm-Message-State: APjAAAWuFBifMFs0kxn5HwyhEQr88PtbeFPJTlfdD/PDdT7GMEN3EcSn
        iDdKwbtAi67ai+kMcEiAlGI8vQ==
X-Google-Smtp-Source: APXvYqyx2JA4MvxWhrdu/0kfJBMfhUfJMTRKjD8ZE88ua6+hKC9pOspNXri6m2BemJwk80gNPgiRuQ==
X-Received: by 2002:a25:1cd4:: with SMTP id c203mr70046850ybc.294.1564763643068;
        Fri, 02 Aug 2019 09:34:03 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-32F.dyn6.twc.com. [2606:a000:1100:37d::32f])
        by smtp.gmail.com with ESMTPSA id h134sm17113712ywa.110.2019.08.02.09.34.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 09:34:02 -0700 (PDT)
Message-ID: <a334c768e1bd8fc07db20d86072eb479d27ff027.camel@redhat.com>
Subject: ceph-client/testing branch rebased onto v5.3-rc2
From:   Jeff Layton <jlayton@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Cc:     "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        "Yan, Zheng" <zyan@redhat.com>
Date:   Fri, 02 Aug 2019 12:34:01 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I went ahead and rebased the ceph-client/testing branch onto v5.3-rc2.
There were a couple of patches that went in after v5.2 shipped that
touched fs/ceph and were causing problems when merging some incoming
patches.

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>

