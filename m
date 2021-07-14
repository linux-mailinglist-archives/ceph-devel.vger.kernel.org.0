Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C1E3C8266
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 12:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbhGNKI6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 06:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238359AbhGNKI6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 06:08:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gnO6rFff3wSRFs2HAhZKyRALZUvUxbqM5RLKTpN0QWY=;
        b=N3Dyr0/YBHZ6RwgTAY/icwoi5NUwKNnAeTRgkeE05TXHPZpyFK0HDdeD+E66JJKA91zNge
        m44Yz+FB7kwNHlSYwH1At5tOlK2ZDQSR0wGKLJ/MYWfS98ETKuFwQFpRtj2WTogSn1FqqB
        6mls/+ZTM9wvI5SgLlv1Ji/z8EX6o5M=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-GetLfZuyNQyaE15vfi-zjQ-1; Wed, 14 Jul 2021 06:06:05 -0400
X-MC-Unique: GetLfZuyNQyaE15vfi-zjQ-1
Received: by mail-pj1-f69.google.com with SMTP id f7-20020a17090a6547b0290173de25d141so3410361pjs.4
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 03:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gnO6rFff3wSRFs2HAhZKyRALZUvUxbqM5RLKTpN0QWY=;
        b=VYnMVY1RH2huNq7mmAU11ZS7Yo8mOqyb3TnRlzsx1lQIUV0OadWjW5EdKpHoDj01vb
         BdjSfhWyIkpd/aqGPf+d+GJTb+c3blUSK73FLl85XOXnCyOzd4+gVD4XcTB5xr76EDPM
         zltxSXHoEiZEgCXTtCBOyHylMIkNAsMhv7e3nMsMOBoqhg0JTL5buAZ4EacvzxBIiMbV
         pB1IPVbZzYoHGdo0+6fXNZqyS1moN9PIruPkxJd+SAO2HbKNhlBPI8m7RANql7o5smH1
         varZ1+xLTwnPEf/nxyvO4eLoWBHwDuQmYb/aeP8gtEhaRf4+2/CwVVpe2jYq9W9GrydX
         h6FA==
X-Gm-Message-State: AOAM532cYx9cgbv2FBEZXkbHRBTuNR57qnD1a6+sGmrkuRw/ZX5lAU5r
        yuQ46QQcqE9KnI4bxBK46dmxze+rRJM66hExbzO/2RWfwgUmLwlsHAQ/cQcuhAoOkXbaNG5ob2e
        mONQbKQ3gNM7gEYnawQdnWQ==
X-Received: by 2002:a62:154f:0:b029:331:b0d6:9adc with SMTP id 76-20020a62154f0000b0290331b0d69adcmr1406584pfv.73.1626257164348;
        Wed, 14 Jul 2021 03:06:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzROGDwzhvky9BhG8eh8xBjS7Ci2BCPn6RZcZjnJrTJlzhpIrn9vVGvkjWwGrVwXLuBYDhmwA==
X-Received: by 2002:a62:154f:0:b029:331:b0d6:9adc with SMTP id 76-20020a62154f0000b0290331b0d69adcmr1406571pfv.73.1626257164153;
        Wed, 14 Jul 2021 03:06:04 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.217.185])
        by smtp.gmail.com with ESMTPSA id 125sm2227030pfg.52.2021.07.14.03.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 03:06:03 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 0/5] ceph: new mount device syntax
Date:   Wed, 14 Jul 2021 15:35:49 +0530
Message-Id: <20210714100554.85978-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v4:
  - fix delimiter check in ceph_parse_ips()
  - use __func__ in ceph_parse_ips() instead of hardcoded function name
  - KERN_NOTICE that mon_addr is recorded but not reconnected

Venky Shankar (5):
  ceph: generalize addr/ip parsing based on delimiter
  ceph: rename parse_fsid() to ceph_parse_fsid() and export
  ceph: new device mount syntax
  ceph: record updated mon_addr on remount
  doc: document new CephFS mount device syntax

 Documentation/filesystems/ceph.rst |  25 ++++-
 drivers/block/rbd.c                |   3 +-
 fs/ceph/super.c                    | 151 +++++++++++++++++++++++++++--
 fs/ceph/super.h                    |   3 +
 include/linux/ceph/libceph.h       |   5 +-
 include/linux/ceph/messenger.h     |   2 +-
 net/ceph/ceph_common.c             |  17 ++--
 net/ceph/messenger.c               |   8 +-
 8 files changed, 186 insertions(+), 28 deletions(-)

-- 
2.27.0

