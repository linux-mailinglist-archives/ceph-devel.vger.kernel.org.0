Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9687A1FAA43
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 09:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgFPHor (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 03:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgFPHop (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 03:44:45 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3DBC05BD43
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t21so13501819edr.12
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SJD/BcaajowqGbfRIlo4KiGKQZt2RsYKscYaimJtsFk=;
        b=OC2DxrxFvCQhqifiMhtIdWjMs77i1j/XB9727l5g54Bh/nZzLEhE7GXI/rgkGCW2rA
         pXlJmOlK8IDix7A0lIO4kpjOrzxFcILPelbN0FcXj3DH+v8YG6T5asTrSDoNj83oobxH
         Q4hsmKR6TiJZYNWq119q3uqOm+CLV5AORwMOWHVUo4UGAggvyzrnW/B83sMFfOfP2Po+
         S1R1DDglSu+zBsB8PsMLZevEoyPubS43uCMQr9dGBLfTOb5LU5yv7B7IfgWcuxT8kWU4
         IWJLVRYBHuovIspBUeEY2HhXX+RTp/EVPWH9J4qSUs+jdyCe4FuLmH0oJRVmX4aGxZD9
         70MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SJD/BcaajowqGbfRIlo4KiGKQZt2RsYKscYaimJtsFk=;
        b=W/30TUS53Eh8yvzEmojiGon0Vwrv9NPTb2l0oi3SHPHjPpazbmV9b9Ueslaa1fbTdN
         ciHYO7EWqv35xu+Kq0TJk3+HCW9ApV0E3ryvk1ipp5Kp+1zEkTGPJIUgNw68L67ldGlh
         bWdmFxSP9uRrF+EZNI/AbH6+X+/3Z74AVkphHKNw0F5vx/CHcSJRGIIkbE4D2vpqt8D0
         1EI0758lLXFmS8PiD6ESUnzAYwDX21qYEmv5OiP92syWw2TC3QCC6t54TkdIDZwS2/Vq
         E/1zhfZ0A+AaJjL9U469Z4VmZ/9CEkDSiKAEli5/U73LoWnUiz47zxjARgimaLmj0Gm+
         wBaA==
X-Gm-Message-State: AOAM533BlB8I25wx/5uL/+cQ/T7K4bqOSGy21vpfdCamY1mQit9moDcS
        Ftd59TlNvrWEORSL5svWZkewC8gncG4=
X-Google-Smtp-Source: ABdhPJy2zgrcmizy1IjncqSC75KZQLW7wT7Ji+PAZoztMK6mg9dV4Ls7elLd/7Z6vaGp37OpeOso3g==
X-Received: by 2002:a05:6402:1ca2:: with SMTP id cz2mr1322195edb.15.1592293482099;
        Tue, 16 Jun 2020 00:44:42 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id j2sm9684562edn.30.2020.06.16.00.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:44:41 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/3] libceph: target_copy() fixups
Date:   Tue, 16 Jun 2020 09:44:12 +0200
Message-Id: <20200616074415.9989-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

Split into three commits for backporting reasons: the first two can be
picked up by stable, the third should get some soak time in testing.

Thanks,

                Ilya


Ilya Dryomov (3):
  libceph: don't omit recovery_deletes in target_copy()
  libceph: don't omit used_replica in target_copy()
  libceph: use target_copy() in send_linger()

 net/ceph/osd_client.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.19.2

