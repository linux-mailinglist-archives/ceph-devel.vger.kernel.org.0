Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1663710B272
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 16:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfK0Pb3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 10:31:29 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44585 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfK0Pb3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Nov 2019 10:31:29 -0500
Received: by mail-lj1-f194.google.com with SMTP id g3so24918720ljl.11
        for <ceph-devel@vger.kernel.org>; Wed, 27 Nov 2019 07:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=FgDsPfj1gyS6S65TVD3JUynSP32FL1jGL5TymhXBml0=;
        b=ewdckFfBQvhGxIbUXrfPAQpB2pHFa+VhkugxLeAQKR8it4hzmrNbBmfImIr1kIpq7f
         eeVkEF6r6Fe+o5so/L/LKjNXJwKY2Jly4SVqyICoNzJWNdYOa42wPjpRz7pSRr/I3TRu
         Jmy1pVbMmTzt7p4tAQvnOxTCC39I8Y++O6UCQ80EYPKv+y5ldww6+LulW+d8bCE4fwGZ
         ZlBaAHv6UrbfMg26BWQsJJ+Lgsd3DsGkJc1xs/VRE2y0+rOTiLsru5YnLtoL+C9lckR0
         4dI2tyB3lI2CoK4fWNqxL+uFxeONGZXoY4YqPZAKb8fuwXc8tB/EKH6s5bNbnicpky9f
         7MEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FgDsPfj1gyS6S65TVD3JUynSP32FL1jGL5TymhXBml0=;
        b=IcI0eHRaO+OlT05TnkRu5ELFsqtTSAFzgHYM4rUm/wmQg86EQHgB4VRYOBvHvQAYis
         rNuzxLHQBobdNUNgLYxqY1evDDEXo2XpO6rXxFAk0qQmSXmu8/xbWUtIyeR6iivYwWmM
         gR5Hqiekx2M0nwm7gw9Vk/oevZCVyWxJCGKR1oZpPSkunSGZ/u6RdjONOdQ8E1oZwjgC
         oh7iP+IY3RkwDbgIAiCQPSgzog9ou0vGViQYNBXwzlyx3uUdIPwz3tyGFwfAVReUNt3l
         HbEVct5kPhXKgqK8DnGR9gZnSYUX+/y4MFhT91mZVlg1fZIaqhLDYiCjJ9ZxCi4Mrrft
         kABw==
X-Gm-Message-State: APjAAAUFl9U7BdmxGr5mGTc82j58APweKGnfL/p8KwhtBXh9FRlsFMpD
        X1quiBLZro75qhrTsXedWtONBmXoqgTygUDng0DLddQ6
X-Google-Smtp-Source: APXvYqwn8w5hMw/ehmvwWdt44qiOH3/v5vLt4sex07w0ArtpTA/bC5WqR1ZOwZx0UQ/szjjOqwIzxoY9535qveluGGk=
X-Received: by 2002:a2e:3216:: with SMTP id y22mr16899871ljy.95.1574868685856;
 Wed, 27 Nov 2019 07:31:25 -0800 (PST)
MIME-Version: 1.0
From:   Vincent Godin <vince.mlist@gmail.com>
Date:   Wed, 27 Nov 2019 16:31:14 +0100
Message-ID: <CAL2-6b+A2tQd=pMoXRewK2KeakDpy0X40vDg0OTWk-ZAm5RfmA@mail.gmail.com>
Subject: mimic 13.2.6 too much broken connexions
To:     ceph-users@ceph.io, Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Till i submit the mail below few days ago, we found some clues
We observed a lot of lossy connexion like :
ceph-osd.9.log:2019-11-27 11:03:49.369 7f6bb77d0700  0 --
192.168.4.181:6818/2281415 >> 192.168.4.41:0/1962809518
conn(0x563979a9f600 :6818   s=STATE_ACCEPTING_WAIT_CONNECT_MSG_AUTH
pgs=0 cs=0 l=1).handle_connect_msg accept replacing existing (lossy)
channel (new one lossy=1)
We raised the log of the messenger to 5/5 and observed for the whole
cluster more than 80 000 lossy connexion per minute !!!
We adjusted  the "ms_tcp_read_timeout" from 900 to 60 sec then no more
lossy connexion in logs nor health check failed
It's just a workaround but there is a real problem with these broken
sessions and it leads to two
assertions :
- Ceph take too much time to detect broken session and should recycle quicker !
- The reasons for these broken sessions ?

We have a other mimic cluster on different hardware and observed the
same behavior : lot of lossy sessions, slow ops and co.
Symptoms are the same :
- some OSDs on one host have no response from an other osd on a different hosts
- after some time, slow ops are detected
- sometime it leads to ioblocked
- after about 15mn the problem vanish

-----------

Help on diag needed : heartbeat_failed

We encounter a strange behavior on our Mimic 13.2.6 cluster. A any
time, and without any load, some OSDs become unreachable from only
some hosts. It last 10 mn and then the problem vanish.
It 's not always the same OSDs and the same hosts. There is no network
failure on any of the host (because only some OSDs become unreachable)
nor disk freeze as we can see in our grafana dashboard. Logs message
are :
first msg :
2019-11-24 09:19:43.292 7fa9980fc700 -1 osd.596 146481
heartbeat_check: no reply from 192.168.6.112:6817 osd.394 since back
2019-11-24 09:19:22.761142 front 2019-11-24 09:19:39.769138 (cutoff
2019-11-24 09:19:23.293436)
last msg:
2019-11-24 09:30:33.735 7f632354f700 -1 osd.591 146481
heartbeat_check: no reply from 192.168.6.123:6828 osd.600 since back
2019-11-24 09:27:05.269330 front 2019-11-24 09:30:33.214874 (cutoff
2019-11-24 09:30:13.736517)
During this time, 3 hosts were involved : host-18, host-20 and host-30 :
host-30 is the only one who can't see osds 346,356,and 352 on host-18
host-30 is the only one who can't see osds 387 and 394 on host-20
host-18 is the only one who can't see osds 583, 585, 591 and 597 on host-30
We can't see any strange behavior on hosts 18, 20 and 30 in our node
exporter data during this time
Any ideas or advices ?
