Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7777F32719
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 05:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfFCD7Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 2 Jun 2019 23:59:25 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36290 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfFCD7Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 2 Jun 2019 23:59:25 -0400
Received: by mail-lf1-f67.google.com with SMTP id q26so12406069lfc.3
        for <ceph-devel@vger.kernel.org>; Sun, 02 Jun 2019 20:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VMIB4mutW1IZgqPZ/WlYT8Sn3VZz+53VhTpx9F6HzGo=;
        b=pcXPQvNLGemZatx1rys2JhRNt6FHucoDmgIshU9wKy6QDboHRtS0sTnlGLfbB/IHS2
         /G6lxQWGoWajAAgHToewubdqMkJJO5PUjLSzLdhWXcRTlSay6Hzj5vX5wrqo4OtSz9KT
         ige9avA1SHrrzewq8+BpWY13hsr4/7EiJXKJhjl5nzKv9EoB/AUASNg47pvN078fDMGB
         LwFPM0c/Gh+W5uiq1lf9TJxPkFgN7gFswBm+s7WTRsTM8gNCjLTddpd7eEQgem2nL4jU
         xyzAY4+KGGATRUeiSe5fswvsaXCVN4PPN92FW6K01tzq0vAFFSCBD+czrsdOx6wGenAJ
         YXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VMIB4mutW1IZgqPZ/WlYT8Sn3VZz+53VhTpx9F6HzGo=;
        b=ueh5BDzneTD0IE0qTmrlfNHDfUMqIXy+TTpvfd1WVbyfTOfYoxb7zoW07sG4dsPLOI
         jrycNeSjlRRomu4SV9SOz5Rn8hRM6BYXLUBe6kA2tTyEWDhp0oGNtXQJ8RBA1yKwAs3w
         STpHrfNP+xG8p3fY2nRnIQOWO/DV10PsB9/lDOxd9jbrXjwZRx9hfJlobCssiVX5UgXC
         Sn4rtF7vB/RU3a9eNEoMSxk7yrUcHN56FJuUCtmt/FXuybw6STYjpnHZ4NkeTCW1HtiT
         AOwKA+OpcqNImKUcdSokfNECx7+7nexvjjB0jkZCNWNDGYp8kDBoLfW9XJNMvOtoripE
         tGXg==
X-Gm-Message-State: APjAAAWVqPfrl36HU6k7amkXo9OPlOpQj0mYYnFBBIlMx6OoVHIBdJ2I
        ATL44KvmNlzl0RICH2VumqcABQu0KbJ508UPzlI=
X-Google-Smtp-Source: APXvYqy6WzY7/QnTFPUlf582sC831Vg1Yn0TxSE+1NDivOKaJwkh2xmkuTbn866ViAJgS3F8vTNk9NtPM9Qf46TQwz4=
X-Received: by 2002:ac2:4908:: with SMTP id n8mr11890770lfi.10.1559534363928;
 Sun, 02 Jun 2019 20:59:23 -0700 (PDT)
MIME-Version: 1.0
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Mon, 3 Jun 2019 11:59:19 +0800
Message-ID: <CAJACTufz=iQUcPW75vxX0qM6xK7Sd8XuDHrdZrAt4B9uGJGvog@mail.gmail.com>
Subject: [PATCH 0/2] control cephfs generated io with the help of cgroup io controller
To:     Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Xuehan Xu <xuxuehan@360.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, ilya

I've changed the code to add a new io controller policy that provide
the functionality to restrain cephfs generated io in terms of iops and
throughput.

This inflexible appoarch is a little crude indeed, like tejun said.
But we think, this should be able to provide some basic io throttling
for cephfs kernel client, and can protect the cephfs cluster from
being buggy or even client applications be the cephfs cluster has the
ability to do QoS or not. So we are submitting these patches, in case
they can really provide some help:-)

---------------------
 fs/ceph/Kconfig                     |   8 ++++
 fs/ceph/Makefile                    |   1 +
 fs/ceph/addr.c                      | 156
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/ceph_io_policy.c            | 445
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/file.c                      | 110
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c                |  26 +++++++++++++
 fs/ceph/mds_client.h                |   7 ++++
 fs/ceph/super.c                     |  12 ++++++
 include/linux/ceph/ceph_io_policy.h |  74 +++++++++++++++++++++++++++++++++++++
 include/linux/ceph/osd_client.h     |   7 ++++
 10 files changed, 846 insertions(+)
