Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD371EAFDE
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jun 2020 22:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFAT6h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 15:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgFAT6h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jun 2020 15:58:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48124C061A0E
        for <ceph-devel@vger.kernel.org>; Mon,  1 Jun 2020 12:58:37 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id q25so777705wmj.0
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jun 2020 12:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMNjjpRaHIlRsZtf9cXN7GmSrbdBGGhcu01hiK4G/1M=;
        b=Y5MRhRhzMlMatU+r6lxyyqmgruZiXKxjLg6HXMswm18uLv9iloDfY5VE3KPC136YcB
         Zx91+aS386Xs4TK/ICjr01FxT7FNG0Ii+VqpARsy7i2RU1LLcUUjigtOsdiBnLmNxMLl
         P8/Qh519GS906FD1DyBa6vufw9bQABdgrZmQpvzHHf709BXgD9zz/AGDPZ88P/ZbCuFB
         IQHCZWf5zL++byXhEQfL/Bsl07nGWRGdF/Jqk9Ftop/x3uBcWchCf8Sla5MujD5z9kEH
         dF2dyE28y4OW5gpWq9u+8coFoi8hfEggtya8mvnXUaI+pFJPLrybdUvq3qaXdbnVKOMe
         +6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wMNjjpRaHIlRsZtf9cXN7GmSrbdBGGhcu01hiK4G/1M=;
        b=LzKcFrzK69PPf0A1roI+i1O+sV7g+xA62xVIhNXC203HMGXouafrrTzZB6zYetK836
         +bTDOHLZ7/0U53MMCYyuL7MnUdVeGUXiZ33jsUkiuc/786o9MEIEA4qJniYl3cL0a0vF
         6BrtnWvIDHPpHjmdjFQRScHa/Elg6Zs6+JlWyfH6iA82QCRzzSHzp9bYWhIoQiBMAg7t
         ld6ejHgAXcSQZqj18Lux2nhQcXHJ28cGOT44VVOsG0I6istYJY4bVpYlg0sTDkyvhDXQ
         cQZLbCHK5AzRFa2U2xx65SSldFKpMdwyWjz2+fmmopgryCP7B7DIzQakGyrEfxtenISX
         r+nA==
X-Gm-Message-State: AOAM532mSRv9/NCMh6m3PHKy1QmpJDWsPdKKMLPyIa1ItI0p8BiRZDx1
        8sNEk+ypwXLUOdf0aMbmqrz7VNeGW9A=
X-Google-Smtp-Source: ABdhPJzFwwam7qqJ60Pyz3U4IuR5MI9ZA0msMaZdiUE3yjySpKf7K1ACDQUoZ+vXt0vRhDZQv3Zx5Q==
X-Received: by 2002:a7b:c8d6:: with SMTP id f22mr829214wml.188.1591041515786;
        Mon, 01 Jun 2020 12:58:35 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id t189sm574008wma.4.2020.06.01.12.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 12:58:35 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jason Dillaman <jdillama@redhat.com>
Subject: [PATCH 0/2] rbd: compression_hint option
Date:   Mon,  1 Jun 2020 21:58:24 +0200
Message-Id: <20200601195826.17159-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This adds support for RADOS compressible/incompressible allocation
hints, available since Kraken.

Thanks,

                Ilya


Ilya Dryomov (2):
  libceph: support for alloc hint flags
  rbd: compression_hint option

 drivers/block/rbd.c             | 44 ++++++++++++++++++++++++++++++++-
 include/linux/ceph/osd_client.h |  4 ++-
 include/linux/ceph/rados.h      | 14 +++++++++++
 net/ceph/osd_client.c           |  8 +++++-
 4 files changed, 67 insertions(+), 3 deletions(-)

-- 
2.19.2

