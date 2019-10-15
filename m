Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C6AD6DD4
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Oct 2019 05:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfJODct (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 23:32:49 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:36022 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfJODct (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Oct 2019 23:32:49 -0400
Received: by mail-io1-f42.google.com with SMTP id b136so42671929iof.3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2019 20:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=A8ydLZNvRYJn15d1z6tTisAxXDLpEJbswKdw3i7PRJE=;
        b=a2qzi5dmNKDCzsiEc6p59gz26SzCBj/A3MQj60rUh2hXrkEKCyHYO9A7jJmRV8CqSZ
         mAK1gNxqPpSwqQvg90mwJDerdjW+82jCn7QGmMmDuIdGr4lE1Lhp4R9jDBq1uw4N4Kf+
         iqXysRU0nwri55PsNRPZEycJEnlasQDVBYmVfSchy/efnyHESDNcfe3GVAoHlu5NM70u
         avL+hbsWiDlT2RE/IiK07C7O2Q0Rj6uBEcqH3BlUbpOu2vfE9A5NjiCUQObtu/Vd05J1
         I3YyZZ1WzxnlfZSKiSz4Khm8ecpf9WyX7Y06EsnyXKCUtfyzUJbAj6ZmpWt0lasS4yAz
         gGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=A8ydLZNvRYJn15d1z6tTisAxXDLpEJbswKdw3i7PRJE=;
        b=QZM5JMyyF+JFaQ57Q40OQlLIVuL6sY5mng7MUwAHKDt74KZuhiwqGsxjcMPv4aVPTS
         YJ3s8Hnvr9O7qSQj/ibE94kEiWGegZ0b/IUgN3HM/kJH8TD7MB50aRldQnn1BYusOLrU
         QFDQHpA5cMygyjTcQYeVjPjbEA2DwnsgH6tUOub8h0sMxHhoI5aFgk1v32xQNMsy6QAn
         w443BWtT2p1zQnWVHaxLbu2uufy6xmatTg7KG39xmGPjv81CbPM1HdE7YieM2NpKNwpu
         IIF8p8bIJbulvYRfYyQO2qOH0lbRC1p/yLTi7vaUvD4/vWGTMgFV2nxVSmwUOBeCu21V
         /MLg==
X-Gm-Message-State: APjAAAUKtHDJBePESbMwgmKkOhySKQppdKhGf40tjD8D5/MA/501K7Jm
        jzUDcyWn1nEc321v2LHV/3kDk2ltpuLBTTM+3NffGMrF
X-Google-Smtp-Source: APXvYqxWRCu1bT/7YWIkr082Zv6ZVDjENPqQ6SP2HkHrISpeGaRszO6tqBrV0nejxAY0UF9ZDwsTq0emWHzLlVt2W/Y=
X-Received: by 2002:a5e:8219:: with SMTP id l25mr3608237iom.292.1571110368018;
 Mon, 14 Oct 2019 20:32:48 -0700 (PDT)
MIME-Version: 1.0
From:   Xiangyang Yu <penglaiyxy@gmail.com>
Date:   Tue, 15 Oct 2019 11:32:34 +0800
Message-ID: <CAE5T3Nx27Wgt1TR4d-wtL2w2a3fT6_Mkvnjz2PFdMP+6dwP7RA@mail.gmail.com>
Subject: OSD reconnected across map epochs, inconsistent pg logs created
To:     ceph-devel <ceph-devel@vger.kernel.org>
Cc:     Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi cephers,
I met a rare case and got inconsistent objects.
As described below:

Assume pg 1.1a maps to osds[1,5,9], osd1 is the primary osd.
Time 1: osd1 osd5 osd9 was online and could send message to each other.
Time 2: old5, osd9 received an new osdmap that showed osd.1 was down
,and at the same time, osd1=E2=80=99s public network was down
manually(physical down)=EF=BC=8Cbut osd.0=E2=80=99s cluster network is stil=
l online.
Time 3=EF=BC=9A
Because of receiving an new osdmap that showed osd1 was down, osd5 and
osd9 shutdowned their connections towards osd1 up (through mark_down()
). so there were no existing connections for osd1.
As for osd.1, connections between osd.5/osd.9 encountered a
failure(disconnected by osd.5/osd.9 explicitly) and were going to
enter STANDBY state . As a consequence, these connections were still
existing( their cs_seq > 0).
After a short while, osd1 generated two scrub operations(enable
deep-scrub) about updating some objects version
info(scrub_snapshot_metadata()), and was going to reestablish
connections among osd5 and osd9. When osd1 was sending the first
operation op1(by send_message()), the cluster messenger would
reconnect the osd5/osd9 and then placing the op1 in out_q=E3=80=82During th=
e
connection was enter STATE_OPEN, there was a RESETSESSION between osd1
and osd5/osd9, which lead osd1 to discard the msg in out_q (by
was_session_reset()). After the connection was established, osd1 sent
the second operation op2 to osd5/osd9. Have this attention : OSD.5 and
OSD.9 was updating the osdmap, but have not committed the update. So
op2 did not discard because of mismatch epoch and eventually applied
to osd.5 and osd.9.

Eventually, there two pg log were recorded on osd1(op1,op2), but only
one pg log(op2) on osd5/osd9.
Time4: when osd1 public network recovered soon, during pg peering, the
primary osd(osd1) could not find any difference about pg log among
osd5 and osd9. When pg 1.1a deep-scrubed over, there would trigger an
inconsistent error about object version info(the version info op1
associatived).
This is a rarely situation we meet with. In some case, I think this
would cause the msgs out of order . If I misdiagnosed it,please tell
me.

I have talked with gerg about the problem before.
This is my PR:
https://github.com/ceph/ceph/pull/30609
(I insist on my pull request, because in my opinion, there is no
difference between peer and losslyness connections, any endpoint can
connect to another endpoint. If the osd.5 and osd.9 start a connection
,then the op1 in osd.1 can not discard and would walk through a
replace session flow. )

The event is recorded in tracker:
https://tracker.ceph.com/issues/42058

Anyway, I want to receive any advice on how to resolve the problem
properly, thanks.
