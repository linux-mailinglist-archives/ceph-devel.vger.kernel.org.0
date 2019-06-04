Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30C34761
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 14:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfFDMz5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 08:55:57 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:45298 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfFDMz5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 08:55:57 -0400
Received: by mail-lj1-f177.google.com with SMTP id m23so1282410lje.12
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 05:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oCLIfL/F5loANCgqOWoirwmhcbSlxcH6xEBcBt0BVe0=;
        b=qGQSUMN5F4y+ro2wfKZ3eoU3CmBESCUlWjEO9fe72F5mj/9Dz/hD8HUe4m2CWOsyxI
         +tAXufczNuruqziCOqGJODaZz8VnbLMzoPeFoWEMfs0nDCmqjYrlzUNPZE2cFlHn6FZd
         VawYWm3nMRHNIzlxgCKluJJIz+BjRghBH6HYHqYoXpr7hyFdliiBZptNiQHiPiZ3KNiD
         ly2RiIrNc8fL85TMBjaFep5yKh3fpbFv4aODSui7l4y2r1PjtuDYQwYE2+wI94qq29uL
         bNP3TtzF/IWF6asHZdelpuiOxz7hrAjLXPzIokmPLMaIuohSeFX9kJA68jvBqpvKXGF1
         6OKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oCLIfL/F5loANCgqOWoirwmhcbSlxcH6xEBcBt0BVe0=;
        b=XMr4UM1+P7n2jwvtc+y7AI9j1aiYYIOPFAlDU2iPsbDHb/pI7wKRlU8I6wIjl0Gm/h
         S6+tmR/l3PEDzifEGcqhC5UsivJuGzC0sIMS1jXPxZBGpOKu4ocu6YFxV6c69VgBXB3r
         djFy+b9rNyTCCmMosWcKG6pJmQo+JL5R/uFK3FEUQ0fAq8PWaUZWhZe3tJl/xDP4ZXLj
         Jt+fbu/TG5PSZZPIOzIJVqTxF/McUWlHzQTb5NrEeVgZDtNQRTTB4ePbdDkYVkC5L510
         r+XMzhO7rLns27s3wz+r9zEggOOf2SkNLg2i9SA6NQphNYrvzqU8XunTpRnY+xE8QzGU
         gbrQ==
X-Gm-Message-State: APjAAAWgJ66UyPZpRsXQQS2VHePl21FVRtcV3DzGzsrWLG/okV/7VXCv
        ce2D3v4xLrFwySg1VvW+cnAtTJ0iekJRIaSCKW3qdrYoDRSVmA==
X-Google-Smtp-Source: APXvYqyfOxzVDTSHBzEq5G8HBrsWTs3Ap6YrgRxZTu0SL/mevCBhsbZoNy9OsNFVwdCMoPB++AqRgc1vVt9JU5ZDXBg=
X-Received: by 2002:a2e:5b94:: with SMTP id m20mr7225894lje.7.1559652955352;
 Tue, 04 Jun 2019 05:55:55 -0700 (PDT)
MIME-Version: 1.0
From:   Ugis <ugis22@gmail.com>
Date:   Tue, 4 Jun 2019 15:55:44 +0300
Message-ID: <CAE63xUM=y_EJjtdzJud_=cL4-iPX6CBBUMGbAQ5q+yZ9RCr8iA@mail.gmail.com>
Subject: rbd blocking, no health warning
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

ceph version 14.2.1 (d555a9489eb35f84f2e1ef49b77e19da9d113972) nautilus (stable)
Yesterday we had massive ceph reballancing due to stopped osd daemons
on one host, but issue was fixed and data migrated back till HEALTH_OK
state.

Today we had strange rbd blocking issue. Windows server used rbd over
tgt iscsi but I/O in rbd disks suddenly stopped - shares did not
respond, could not delete file etc.
Tgt iscsi daemon side logs showed following(after googling I conclude
these mean ceph backend timeout on iscsi commands):
# journalctl -f -u tgt.service
...
Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 7a5f0400 6
Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 785f0400 6
Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 765f0400 6
Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 755f0400 6
Jun 04 12:29:35 cgw1 tgtd[12506]: tgtd: conn_close(92) already closed
0x1b67040 9

At this point ceph health detail showed nothing wrong(to be clear,
there was and still is hanging one active+recovering+repair pg, but it
was not related to pool of windows server and below mentioned osd.35
not involved - so should not have any effect).

I started to dig monitor logs and noticed following:

ceph-mon
...
2019-06-04 06:25:11.194 7f6dc9034700 -1 mon.ceph1@0(leader) e23
get_health_metrics reporting 1 slow ops, oldest is osd_failure(failed
timeout osd.35 v1:10.100.3.7:6801/2979 for 633956sec e372024 v372024)


As "failed timeout osd.35" seemed suspicious I restarted that daemon
and I/O on windows server went live again.

ceph-osd before restart : tail -f /var/log/ceph/ceph-osd.35.log

2019-06-04 12:42:08.036 7fab336e8700 -1 osd.35 372024
get_health_metrics reporting 27 slow ops, oldest is
osd_op(client.132208006.0:224153909 54.53
54:ca20732d:::rbd_data.5fc5542ae8944a.000000000001d0dd:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
3538944~4096] snapc 0=[] ondisk+write+known_if_redirected e372024)
2019-06-04 12:42:09.036 7fab336e8700 -1 osd.35 372024
get_health_metrics reporting 27 slow ops, oldest is
osd_op(client.132208006.0:224153909 54.53
54:ca20732d:::rbd_data.5fc5542ae8944a.000000000001d0dd:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
3538944~4096] snapc 0=[] ondisk+write+known_if_redirected e372024)
2019-06-04 12:42:10.040 7fab336e8700 -1 osd.35 372024
get_health_metrics reporting 27 slow ops, oldest is
osd_op(client.132208006.0:224153909 54.53
54:ca20732d:::rbd_data.5fc5542ae8944a.000000000001d0dd:head
[set-alloc-hint object_size 4194304 write_size 4194304,write
3538944~4096] snapc 0=[] ondisk+write+known_if_redirected e372024)

Here I noticed pg "54.53" - that is related to blocking rbd.

So in short: rbd I/O resumed only after osd.35 restart.

Question: why ceph health detail did not inform about blocking osd
issue? Is it a bug?

best regards,
Ugis
