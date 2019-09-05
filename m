Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7ACDAA092
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Sep 2019 12:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731857AbfIEKzs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Sep 2019 06:55:48 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:34669 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730973AbfIEKzs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Sep 2019 06:55:48 -0400
Received: by mail-lj1-f175.google.com with SMTP id x18so1997343ljh.1
        for <ceph-devel@vger.kernel.org>; Thu, 05 Sep 2019 03:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=U7WoZ+r/dLtm5QVtP7FosO7Kdqw58r2fPaGcoBT5Euw=;
        b=nkORy/NREfLo9O/MkUxDv42h5C8bSkKvqweQvpOjwGiq6XsK1fkpcH8MWC8HPNo1J5
         tHKvdtyt5wfvwrlQekfpiCdEqPL+Q2bqkFwyS65V11253ZKT9NgNMSRdX7TWQytwAUhT
         am//2bRtV1EGFZDCqDCedoAiWT2cL9DalYcU4YIm5wmafnwR+na55Q7ie0Fnn1c6pBs/
         f7naQiKiFYyHn2FbjoWwSq0Ix62DGIA4t0I1N8dWGohSIk6Y8NzmNrdg+8nKtPt+obfh
         Sxvn9g4tU+wdk2TARIaqxOeigbyq6lbTmzCRY5KrjR12bT3tNXgv3OS76OE9temfXdRP
         nT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=U7WoZ+r/dLtm5QVtP7FosO7Kdqw58r2fPaGcoBT5Euw=;
        b=YgGB86KuaAXUWXDjHHaWv9OTVvmeYcDdyfpKauzEaFET4TRFOmWDCqSZCWnvTs3mFD
         z1fUiP7zId7RKZ2KvepWglvHqIR3q4MD3AHoncrS6b+XGoHH6/dkdvknLcSZmhv6l/+Q
         wcOMlHqyVuVFqIDU5hSteMlQVzzyV2WE4qboRLeK29iE9+XvXd94JrrXxFR6FvSU05Eh
         DFir6Hta2OGh1NSULI/TEnGaFrk4MXzPGtc+4OGThfqujIkUdkxx3qEh4tnHlvROIlE3
         SPs5bhNkQ5aB0EZSgk+ZmtJK0roWLBkd7pn8wBtpIwTsCFsg+oTjbrhZVMe+V4XacTRG
         DxGw==
X-Gm-Message-State: APjAAAXwoWh282vupHrd9upE4y8/z3hS8ZQVKbh+0KMuMBnMjOb5ysK0
        zqN3MxAQ545TEIY9ZsktkkOeSspuusmImq5BBbxJnQfOjODPjA==
X-Google-Smtp-Source: APXvYqxro+gtfXFbH5nJQS7tdNsmBgqb9RCienwyVi3sSJHzf8PIAfj/EvDaxz2+Wahn/vuqumy+Y9cRgOvwwkHSAco=
X-Received: by 2002:a2e:b4e3:: with SMTP id s3mr1674719ljm.143.1567680945604;
 Thu, 05 Sep 2019 03:55:45 -0700 (PDT)
MIME-Version: 1.0
From:   Ugis <ugis22@gmail.com>
Date:   Thu, 5 Sep 2019 13:55:34 +0300
Message-ID: <CAE63xUMfe0fgbhr3cSUxoVXm_CtHT3OTKxmXJKNC0h=Gg6hmKA@mail.gmail.com>
Subject: Probable bug when raplacing osd disk with smaller one
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

ceph version 14.2.1 (d555a9489eb35f84f2e1ef49b77e19da9d113972) nautilus (st=
able)

Yesterday noticed unexpected behavior, probably bug. It seems ceph
wrongly calculates osd size if it is replaced with smaller disk.

In detail:
Starting point: 1 osd disk had failed, ceph had reballanced and osd
was marked down.

I did remove failed disk(10TB) and replaced with smaller 6TB.
Followed disk replacement instructions here:
https://docs.ceph.com/docs/mimic/rados/operations/add-or-rm-osds/

Destroy the OSD first:
  ceph osd destroy {id} --yes-i-really-mean-it
Zap a disk for the new OSD, if the disk was used before for other
purposes. It=E2=80=99s not necessary for a new disk:
  ceph-volume lvm zap /dev/sdX
Prepare the disk for replacement by using the previously destroyed OSD id:
 ceph-volume lvm  prepare --osd-id {id} --data /dev/sdX
And activate the OSD:
 ceph-volume lvm activate {id} {fsid}
 I skipped this as was not clear what fsid was needed(probably ceph
cluster fsid} and just started osd
 systemctl start ceph-osd@29

OSD came up and reballance started.

After some time ceph started to complain following:
# ceph health detail
HEALTH_WARN 1 nearfull osd(s); 19 pool(s) nearfull; 10 pgs not
deep-scrubbed in time
OSD_NEARFULL 1 nearfull osd(s)
    osd.29 is near full

#ceph osd df tree
--------------------
ID  CLASS WEIGHT    REWEIGHT SIZE    RAW USE DATA    OMAP    META
AVAIL   %USE  VAR  PGS  STATUS TYPE NAME
...
29   hdd   9.09569  1.00000 5.5 TiB 3.3 TiB 3.3 TiB 981 KiB  4.9 GiB
2.2 TiB 59.75 0.99  590     up         osd.29

Later I noticed that weight of osd.29 was still 9.09569 as for
replaced 10TB disk.
I did: ceph osd crush reweight osd.29 5.45789
Things got back to normal after reballance.

Got impression that ceph did not realize that osd had been replaced
with smaller disk. Could that be because I skipped activation step? Or
this is a bug.

Best regards,
Ugis
