Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70921882DD
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 13:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgCQMEv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 08:04:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35728 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQMEu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Mar 2020 08:04:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so4680635wru.2
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 05:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HSodwCkhWqNjddIaN3m7GDThBtYOZ238++Rr37hN0Mg=;
        b=Us2Fp3TpZzgQYHfXAozXBQozi+TxYHvchTUG2j80IPsnXVkFl0feouzqEA9jNsspsu
         1BC5okzSleGh3Q9LO4lUcfHsOkiu9ash0DdIqeM7djXkvBQj1JQR4Sb3A0qOmEAAkjPG
         acxxuj55vyKMLZpRF+9HoY5yie4VLx2HX+eihycE7DHQAd3dlMDh5ZGC2pVoDlQ1hOTu
         4+/OnSKN593VjfFJH6l9Spwlh9+yHsmTaXJxoN5jb7Rd+qruO3JiOdzKNL3s3VDUB27W
         tLQqSivTXe7f0aK5mN566kaZUk8OxUssLMsMLe8zlzJro71pDD9QAknm35HgdRWGfg6z
         3rBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HSodwCkhWqNjddIaN3m7GDThBtYOZ238++Rr37hN0Mg=;
        b=a0V76lBbY66HR3zCvkuPpKj9vXElew882eX30iLOSFsmtcAQ/YVW1+8Srywss6wQw5
         YK86UYsyQlsaWSW49tv/+sypeRsGgvjG8LZvQG3EtCmvmdXWY50yyjsf1+lgBA4yoagP
         cKrAwndVZRclIK6BCnAPP6Wiio760hchuYqZRQNrgG7i9iVMRuo7ReugY0/+dI2T8M+T
         WZVARI6gilHF0owMZDec4FU0gJonelgNxqbvix1kHpEm/lK0YXI+Y/NoVcIneiHNbkoy
         MTzAlB9QddM4s1g+svm+WmwUbd5cpmv8eRrC8eC9y/wej+XVlnoW1mM69Px53soBz9Qd
         atKw==
X-Gm-Message-State: ANhLgQ0Oonx2hvvtgXohLNL3dpfu6qOayM0KOlnG1s4Skp0aL0JYxFPV
        XQSU3/uDfFXL97twGxoeVm7JamueH3Y=
X-Google-Smtp-Source: ADFU+vtK9zziXvZ3ngVKQeA559x3YMZvzuLfNoYquAkQPchIyvw0H1T+UCnBVUo6YLQSPfgEl2lxeg==
X-Received: by 2002:a5d:484a:: with SMTP id n10mr5996090wrs.251.1584446688673;
        Tue, 17 Mar 2020 05:04:48 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id p8sm4416706wrw.19.2020.03.17.05.04.45
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:04:45 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 0/3] rbd: fix some issues around flushing notifies
Date:   Tue, 17 Mar 2020 13:04:19 +0100
Message-Id: <20200317120422.3406-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

A recent snapshot-based mirroring experiment exposed a deadlock on
header_rwsem in the error path of rbd_dev_image_probe() (i.e. "rbd
map").

Thanks,

                Ilya


Ilya Dryomov (3):
  rbd: avoid a deadlock on header_rwsem when flushing notifies
  rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
  rbd: don't test rbd_dev->opts in rbd_dev_image_release()

 drivers/block/rbd.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
2.19.2

