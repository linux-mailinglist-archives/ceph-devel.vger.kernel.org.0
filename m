Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A903BF701
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 10:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhGHIpi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 04:45:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhGHIph (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 04:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625733775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IHlyXNKqEEGHXPrQZvKUNVppSotgeHQSfHQ1cNUsGOA=;
        b=E9e0UuKa+V1Zk9DYnwmIbFKlmoLSurs3x6RW0tB+WBXTc9dnqcFCEzpBu17KwaJRM6ZI6K
        zHVulKLSDlRXTg4Poah9IWgu6hc4wM5S6xPccAcGamClhJGitrN/VjgFuaZBMqUKmttnaJ
        whXqoYaaXnVkE9SUZ5yb6wRZ3VaWZhk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-_cWQDbdAOdyEF6aKReptIA-1; Thu, 08 Jul 2021 04:42:54 -0400
X-MC-Unique: _cWQDbdAOdyEF6aKReptIA-1
Received: by mail-pj1-f71.google.com with SMTP id a16-20020a17090a6d90b0290172c6293174so3340867pjk.0
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jul 2021 01:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IHlyXNKqEEGHXPrQZvKUNVppSotgeHQSfHQ1cNUsGOA=;
        b=HaM61EONhij1IvFl0+xrze+hBFHQfN2aEKOJQKlcDSakVD8EozE1/icMFbwnqzOfSY
         GKCn6Z+659xOIOxwmXVKfn6+JQsHyybYVH2zzFKq697u/0OqE2iqGbtAPx7ypTBFQR8r
         YvfWOCKuEJK/jISUCQTAP9kSVpUjxEAsFFoeOmLGUkVGp4PxERrHK4YMf1IHJMvOK822
         R+IMxxUH9U2aLeuBwwCxmRq56AetCB+X9Km2eUep7iti8JW8z1DaS3GdDjZeECRMJ9u9
         l+hRVQvREN6I7FY0h2pdJiQ3eZlwem7tUNgQC45RQNduIaK3cvy1wQ7QCqIj6jEfxa/a
         LViA==
X-Gm-Message-State: AOAM530yWWkS2ik/Qc4aO0qV4r8qHI28T74q+PdLHrUv2wEB2taNNkVz
        vssfBl0gaSbpI/hsN8+gokRolzolxjV8nCiZGK/MIkVztzjHBw569zdTFStO9OlIHEyYqoViUgi
        PeXS+WjVBYCln4IRjgvfGtA==
X-Received: by 2002:a17:90a:6607:: with SMTP id l7mr9946154pjj.220.1625733773625;
        Thu, 08 Jul 2021 01:42:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEbLruIuXQ+LAQo9t4B7elGdEpz1F+OGMLj1Vd9wflHVbMY7EucklgOkOcVr/MWj6/3V5Srg==
X-Received: by 2002:a17:90a:6607:: with SMTP id l7mr9946137pjj.220.1625733773335;
        Thu, 08 Jul 2021 01:42:53 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.223.150])
        by smtp.gmail.com with ESMTPSA id r14sm2154588pgm.28.2021.07.08.01.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 01:42:52 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 0/5] ceph: new mount device syntax
Date:   Thu,  8 Jul 2021 14:12:42 +0530
Message-Id: <20210708084247.182953-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v3:
 - generalize addr parsing based on delimiter
 - use __func__ is ceph_parse_fsid()
 - fail mount on conflicting mds_namespaces
 - mention `ceph fsid` in doc

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

  cephuser@fsid.mycephfs2=/path

Note, there is no "monitor address" in the device string.
That gets passed in as mount option. This keeps the device
string same when monitor addresses change (on remounts).

Also note that the userspace mount helper tool is backward
compatible. I.e., the mount helper will fallback to using
old syntax after trying to mount with the new syntax.

Venky Shankar (5):
  ceph: generalize addr/ip parsing based on delimiter
  ceph: rename parse_fsid() to ceph_parse_fsid() and export
  ceph: new device mount syntax
  ceph: record updated mon_addr on remount
  doc: document new CephFS mount device syntax

 Documentation/filesystems/ceph.rst |  25 ++++-
 drivers/block/rbd.c                |   3 +-
 fs/ceph/super.c                    | 148 +++++++++++++++++++++++++++--
 fs/ceph/super.h                    |   3 +
 include/linux/ceph/libceph.h       |   5 +-
 include/linux/ceph/messenger.h     |   2 +-
 net/ceph/ceph_common.c             |  17 ++--
 net/ceph/messenger.c               |   4 +-
 8 files changed, 182 insertions(+), 25 deletions(-)

-- 
2.27.0

