Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A65743FA
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 05:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbfGYD2n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 23:28:43 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:45837 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388946AbfGYD2n (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jul 2019 23:28:43 -0400
Received: by mail-lj1-f180.google.com with SMTP id m23so46451095lje.12
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 20:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=EmpICZQ4LMeM0vAPgknJUzAn35cWby4k9wSSU9JAVxI=;
        b=XbW+bNs+RsXiAxdZDVKnePWsDb6GXQ9GAv+fbRYYzUxVsYWm3gfb/L0zE4h8uP7v/W
         mkeb3fp8ezxEx5AaozKZZyHjuld+M6Jw62F8e0rYmVMlSrIddL8KZ5ETZKBRo2tYmbE2
         RbuTsb4ca5aIrpO+VoHPuhXN2DVl2M57vQppU21D+6LIyC45zgopxEwX3tfAsbnjLSkP
         UIwgvei1ImcqGkXCbwEj4N+ZwFfQCCbAAe/n0ukABTfGXEI7HHR5aG+ct0IbbpYm4IeO
         wKIq2LUCNowIUlL0xUHRug/xbE/MiumhTwHLW9eaanqer0pJEkFGiYrFq5r2vSX9Zb+M
         +YOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=EmpICZQ4LMeM0vAPgknJUzAn35cWby4k9wSSU9JAVxI=;
        b=dTEmwMcBW861bjxMJvkVlXkHUbyJLrG2kI+foSrOSa5m2yhr3djt0jXkcRO/3S4Pcb
         ZoJexpKDKUdc/z8aLZ1LZWzrNfSDC8vq7BziLSIoavzAA/G1unDsHTBWN8tUs8KDImJH
         l8vpel9wdJGApFyMqd9gbZ+6WoNCdGmnEwsJcbvTKkmpuPKL2pL2slkdzqElunevLrIh
         FBVShQjMv0/W4zZ3lqtxxulGHD3mVyAikZaEG4RdViLNfAxP+sPntL45aEjiNLXKOS6v
         9oJYVwzAr0JWDBJzm9yg3q75nTsj2gvHMztXl2dm/14HkxH2H2CAZvu1t1V3cKDCDf/s
         NgtA==
X-Gm-Message-State: APjAAAUVXP5+FvXKmjleJk4TdyyY8OTJrDjbU/40T4qz2Yf7D3f5+k7t
        Br/mNh2uIFVptnp9kDkmP8LZF+P6Le4Og8MUXz+FHSdEUWI=
X-Google-Smtp-Source: APXvYqwiQ1M58Y7aJz4JmYqSRacc9JKfLboI/b9SgZPq3S1W7qeivXSKbxjc4ue4AJrrinQo0At46/CbRq9dPttqE3s=
X-Received: by 2002:a2e:9f57:: with SMTP id v23mr32633169ljk.138.1564025320929;
 Wed, 24 Jul 2019 20:28:40 -0700 (PDT)
MIME-Version: 1.0
From:   Songbo Wang <songbo1227@gmail.com>
Date:   Thu, 25 Jul 2019 11:28:29 +0800
Message-ID: <CAHRQ3VVjW31oiGnoiZfLhpQUGpN6AHrsENTeNUPWpPXs5bAbxw@mail.gmail.com>
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

  1. Set QoS info as one of the dir's xattrs;
  2. All clients can access the same dirs with the same QoS setting.
  3. Similar to the Quota's config flow. when the MDS receives the QoS
setting, it'll also broadcast the message to all clients.
  4. We can change the limit online.


And we will config QoS as follows, it supports
{limit/burst}{iops/bps/read_iops/read_bps/write_iops/write_bps}
configure setting, some examples:

      setfattr -n ceph.qos.limit.iops           -v 200 /mnt/cephfs/testdirs/
      setfattr -n ceph.qos.burst.read_bps -v 200 /mnt/cephfs/testdirs/
      getfattr -n ceph.qos.limit.iops                      /mnt/cephfs/testdirs/
      getfattr -n ceph.qos
/mnt/cephfs/testdirs/


But, there is also a big problem. For the bps{bps/write_bps/read_bps}
setting, if the bps is lower than the request's block size, the client
will be blocked until it gets enough token.

Any suggestion will be appreciated, thanks!

PR: https://github.com/ceph/ceph/pull/29266
