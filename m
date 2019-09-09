Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AB3AD202
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Sep 2019 04:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733155AbfIICiD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 8 Sep 2019 22:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732975AbfIICiC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 22:38:02 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF55934CC
        for <ceph-devel@vger.kernel.org>; Mon,  9 Sep 2019 02:38:02 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id v9so879001ljc.11
        for <ceph-devel@vger.kernel.org>; Sun, 08 Sep 2019 19:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2csDHUwsfZ9vKiM6L0X2VwRtlMfkReR7eWIJEs97n9I=;
        b=ppWGE3RoS/m2V0S5PaRW8wPo5a7cxYypmiIgZRznycrSrAHhF5pp3pVNpj4Ss55AxX
         43sOs9oK2ZfJveDo+msJ7M67wyWqMTy5dZQ7w4Uc1HODSZl0l5wBMlKqfLvZUE3luweC
         4tCVKRcTouSc4qlKKGSIRRr/uSXu7wevPFv8Sn+XjRF+nU/33ih8kdiCQez4nx2/LnyT
         sj5VXvCQnMfObNII3fFOgdre4jlDrpTUTFYpApIk1XnEE6GV3vNiDKM0j6A+Q2Xp6MC9
         3dFpLlk8O1a+Iu87XIPZUAeBuztacNpq3gJEJIZ9vRl8bUKs/pfthI6Gzs+DbSHuzUd6
         kErQ==
X-Gm-Message-State: APjAAAXxJbRXIwji29K5zzd9PIrzZDGCE/xOjqrR/O89payash6IxbCb
        krX2csYhkEjI5KwWeXa/zyzSBqzR9O9n0FYcc2ZaGcFW2Zo9EhixwmgwluIa86nZvPTrU5nv2IM
        9EKV+UYSc5B1ZBFGsjILi1b8bKCZTkqv+Kz506A==
X-Received: by 2002:ac2:5685:: with SMTP id 5mr14715374lfr.5.1567996680890;
        Sun, 08 Sep 2019 19:38:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxGZmYaJY5cSpEn1iRFIhh7BmfdhfV5XG4d8U8zfHZD5XKnAPcas2mS0hePcgyiW+KOEXSRXV5Kqkfyy91xnPI=
X-Received: by 2002:ac2:5685:: with SMTP id 5mr14715364lfr.5.1567996680688;
 Sun, 08 Sep 2019 19:38:00 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 9 Sep 2019 12:37:49 +1000
Message-ID: <CAF-wwdGc2pKHwtA3sjUAqZ_uQgg9yULFhUbbUgZDfcVE3cBK0w@mail.gmail.com>
Subject: Static Analysis
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
