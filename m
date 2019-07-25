Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD10743AA
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 05:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389706AbfGYDKH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 23:10:07 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35871 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389532AbfGYDKH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jul 2019 23:10:07 -0400
Received: by mail-lj1-f178.google.com with SMTP id i21so46527494ljj.3
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 20:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=DJkJxWF1ps5E+hhwLL52dYrcoOtxyy63g6rELX3gyyo=;
        b=PWGjqjYADCM7RnZYFVGHnYQ3SL6kmW2SGgUduPyj8XlpeOwnHPYH/LP+RDaP1wVONw
         rn/6a3D8n6s18PcmGkgErKZdxvZYIpovqEM0nl9dvIyGz6lluljXOCNoVRNPOFopsMXq
         f/ELGyQG8bQjr54brvhaQbUBkKqP5sPirPCtMPhX+ymoj8tsN0v8x0xd4GNrgDSgZuLH
         6+3YRzLI5mjjq45BhexRj+GOsIdXb1rrdpc9MMU9uIxfVPL7fUeW5dbr7O1fdEztfLoI
         F7z3sqMiXLSha5KWmnU9x8WvoN83TCH+BiBOwCz4omTa+58oApRqCCw4DQ9K1pIiNo9B
         EstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DJkJxWF1ps5E+hhwLL52dYrcoOtxyy63g6rELX3gyyo=;
        b=Hhiy7jGeOnExmUwFo8ZXjE2IrIcEhfntOsoFJHIcjbI7vaQzXzYj6IpPHpdpuGnd/i
         9raDFp/342QV+sqVImNgzFwtuHpsSPvyYVzeh3EmVCP06jWOwFscJ8LS7n0qCzp2Y7Dd
         NzdYzXhLgiCiH5f1LL9iC+ZPaqjhm/n+wt6HPd/C/b72AIvUw4ECJMhOI95/37g2PM+K
         2/UO+jeDbndEHkCrEYEWNVeZLp7neudqdtP1591aQUGfIQ4f9dlyn5SCNg1wx0msUQou
         LA9n3En5vnO3iqRs+vMv7bOg/IgpmDnR2W3Wfh4bSdBsTnjqeuJ8YTTDarKYH4IsMQDp
         wbow==
X-Gm-Message-State: APjAAAVj8ZnWGVlgwuXDyIS+X2hHwGkUbJVBaFQWuq9sDTlXBUinAt1T
        8xjNBImdaJWsZGAt705+VxpcAN/b5JWHciJq8In6S58DH6M=
X-Google-Smtp-Source: APXvYqyHzEcOv8AY09uGyuwedWXozAbrV0hJnkXA9A/WJBcen3xrEx1aMTETD/m+YqHMDcwcLEGIhM7zMWE5mEo4dW8=
X-Received: by 2002:a2e:5c09:: with SMTP id q9mr6861315ljb.120.1564024204733;
 Wed, 24 Jul 2019 20:10:04 -0700 (PDT)
MIME-Version: 1.0
From:   Songbo Wang <songbo1227@gmail.com>
Date:   Thu, 25 Jul 2019 11:09:53 +0800
Message-ID: <CAHRQ3VX+fn9y7o8vHXcPU6QxN0aDO4tiAcywoKNQrbCBQwXwAA@mail.gmail.com>
Subject: Implement QoS for CephFS
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi guys,

As a distributed filesystem, all clients of CephFS share the whole
cluster's resources, for example, IOPS, throughput. In some cases,
resources will be occupied by some clients. So QoS for CephFS is
needed in most cases.

Based on the token bucket algorithm, I implement QoS for CephFS.

The basic idea is as follows:

Set QoS info as one of the dir's xattrs;
All clients can access the same dirs with the same QoS setting.
Similar to the Quota's config flow. when the MDS receives the QoS
setting, it'll also broadcast the message to all clients.
We can change the limit online.


And we will config QoS as follows, it supports
{limit/burst}{iops/bps/read_iops/read_bps/write_iops/write_bps}
configure setting, some examples:

setfattr -n ceph.qos.limit.iops -v 200 /mnt/cephfs/testdirs/
setfattr -n ceph.qos.burst.read_bps -v 200 /mnt/cephfs/testdirs/
getfattr -n ceph.qos.limit.iops /mnt/cephfs/testdirs/
getfattr -n ceph.qos /mnt/cephfs/testdirs/


But, there is also a big problem. For the bps{bps/write_bps/read_bps}
setting, if the bps is lower than the request's block size, the client
will be blocked until it gets enough token.

Any suggestion will be appreciated, thanks!

PR: https://github.com/ceph/ceph/pull/29266
