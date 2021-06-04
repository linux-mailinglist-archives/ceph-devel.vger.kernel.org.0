Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F7E39B1CE
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 07:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFDFHP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 01:07:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43519 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhFDFHP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Jun 2021 01:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622783129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=A8NenHCk3Gz2FzCvEPHVnIXvzQiXZ6SmBo3jZXeLhDs=;
        b=Q26KbV0XfKYdimpAW0PzJpBbPliMAiXmRVaN8iWgrCxKTCCnxnS1adsHrbKoI6YlsufSro
        byPJUIdSG9yhP02NlwObwnO7K6w2GO2AH0z7k1EesjyQXaFjLT43jcnon3ym7nIvehJa9k
        lkOVok583sOS95MSQaykGWo9F0BhD2M=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-9H8eHtVCMiaReL_G1-Vs_w-1; Fri, 04 Jun 2021 01:05:27 -0400
X-MC-Unique: 9H8eHtVCMiaReL_G1-Vs_w-1
Received: by mail-pl1-f198.google.com with SMTP id d13-20020a170903208db0290107a6d5fc80so3673214plc.16
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 22:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A8NenHCk3Gz2FzCvEPHVnIXvzQiXZ6SmBo3jZXeLhDs=;
        b=f2jgjXW842XAqvT1rMNSWoamo3er/rFLMjNVqeQrF5hg8z6rJwPT8GgEQb6dFDi+GU
         nJ5Wn8qZBpBiWi8Sun1qcDHU1vhuwC82f5sZVpU1aG6VYmHeG0yBv5g1qHgjkyGBIjT2
         oc0xAAgQhofJG9UrxGSH9Roal7TtSNa7keKN2x/5hVYYJyPNHf1/T6uF1rh+dkfxLwlR
         GnrvdFBBka86vUNVRZu2Dsq9tKteSeltsC9+6OoTKkaN/8muh6p9p3+XTuzeTy4i/MWz
         XrP2O/P1nsXhrRNO9EbjJk1GlD1fLLaMOKJ/YNH+5ITJvuhC10apRwJ1FsbxkX5DalsQ
         85qA==
X-Gm-Message-State: AOAM532vODsoFB8w7765HzMHkuOVtjIUz4kgyTiAbM1civpKnTMiM6uq
        HAIaK0/JEX7HrKYkrdBBXAqfvkqxwsBiodtI9rOhFHt/Us2SyvFvwXntJQAwLtFVrjYuR4WNpYj
        Hd0gMERAoFYZXD3pkzbIYIQ==
X-Received: by 2002:a17:902:9b83:b029:ef:4dd5:beab with SMTP id y3-20020a1709029b83b02900ef4dd5beabmr2517088plp.76.1622783125981;
        Thu, 03 Jun 2021 22:05:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNnTp1+dZODpvsXtF5HLSd5zNdye6aDujif0qJrTmpd3ar9c+PKq9t2+aKYw4DRFc0ymytaw==
X-Received: by 2002:a17:902:9b83:b029:ef:4dd5:beab with SMTP id y3-20020a1709029b83b02900ef4dd5beabmr2517060plp.76.1622783125636;
        Thu, 03 Jun 2021 22:05:25 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.207.151])
        by smtp.gmail.com with ESMTPSA id s20sm3634897pjn.23.2021.06.03.22.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 22:05:25 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 0/3] ceph: use new mount device syntax
Date:   Fri,  4 Jun 2021 10:35:09 +0530
Message-Id: <20210604050512.552649-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series introduces changes Ceph File System mount device string.
Old mount device syntax (source) has the following problems:

mounts to the same cluster but with different fsnames
and/or creds have identical device string which can
confuse xfstests.

Userspace mount helper tool resolves monitor addresses
and fill in mon addrs automatically, but that means the
device shown in /proc/mounts is different than what was
used for mounting.

New device syntax is as follows:

  cephuser@mycephfs2=/path

Note, there is no "monitor address" in the device string.
That gets passed in as mount option. This keeps the device
string same when monitor addresses change (on remounts).

Also note that the userspace mount helper tool is backward
compatible. I.e., the mount helper will fallback to using
old syntax after trying to mount with the new syntax.

The user space mount helper changes are here:

    http://github.com/ceph/ceph/pull/41334


Venky Shankar (3):
  ceph: new device mount syntax
  ceph: record updated mon_addr on remount
  doc: document new CephFS mount device syntax

 Documentation/filesystems/ceph.rst | 16 +++++--
 fs/ceph/super.c                    | 75 +++++++++++++++++++++---------
 fs/ceph/super.h                    |  1 +
 3 files changed, 67 insertions(+), 25 deletions(-)

-- 
2.27.0

