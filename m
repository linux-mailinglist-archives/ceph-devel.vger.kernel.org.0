Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5438B7A0B
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Sep 2019 15:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbfISNDi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Sep 2019 09:03:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46505 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732096AbfISNDi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Sep 2019 09:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568898216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=psad8Mu+qyP93wOnncjM794XoeLfoDXNYa+dqEb0TxI=;
        b=W3fq5ZqHdb26HlOLhZ8w2TRwyV1sS+kQgvyVzNl0TvYznwp2PNjMJBRo6SZ1tpDuFwlMQp
        ljkgzU2OBf+qig3qYKC1xhL2dXQfbVyGCpagGZPFptvLov3yZvSSHggA9dTZwg6yY7/S40
        WlVGfrtDnlz3hvZYckkt4OT2sRgwlbQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-1c9OwVgqO8qhdzKec-HsFg-1; Thu, 19 Sep 2019 09:03:34 -0400
Received: by mail-qt1-f200.google.com with SMTP id x3so3814583qto.7
        for <ceph-devel@vger.kernel.org>; Thu, 19 Sep 2019 06:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oz0SdNcVCM6/mMKzXxjPaGaTgHcubZvH45/s/m/IlHY=;
        b=sp94ph+DWG0bwC9CghhlvFK7790I6J15usebCdHnEF0CZ5Z/Y/OAC8Agw8K24gT1uI
         Pg39H5K9Os5sGuK1AS6mDMDdViMJNfDRpxvS3lRlJzUspj1RaDbU778PeIp1L3lZHLUm
         fVGxIxI8pjyT9AoGG9ABbPMwcJdnbpVnaJr0odXpgPlFPqxpPtlRjTWW2qXOrFo+WwhL
         GRUgDS9JrIyKgbSkpEYiw14yaUqFkdRsWTqU6eeOXRzMM73EVTCQVwCAxiNmLK5bj5i2
         xfADmf6GAuUWxJt08w5rc8wEQ6tpxKeqgTmVPnj9OrQcESlmBO1t2TqQ978Q8f7yjxR0
         7hSQ==
X-Gm-Message-State: APjAAAUSPgr14VafVGG0RiR3sGaNIW+o7wUNvZIpiL73QED6tzmxhQN5
        mF3OvGuHHu6jP0thvUD7Mfg1rlzII8ghMJaoA0s5Q8cC/nPxeNeMW88WNsOoLcdY0idPgI9jB9H
        +dwPgGczXEwHwT4ADsBqStpDT1ZNE6SkaG5WSEw==
X-Received: by 2002:a37:6747:: with SMTP id b68mr2714469qkc.155.1568898214401;
        Thu, 19 Sep 2019 06:03:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxeoEO3eiDePoEYCtzi14FHq1HMBqrwqWnoWJQ9decsuZmCNT9QP4RfuIqfp80zEI2I31rm9aIVDfbPbwucvmE=
X-Received: by 2002:a37:6747:: with SMTP id b68mr2714452qkc.155.1568898214235;
 Thu, 19 Sep 2019 06:03:34 -0700 (PDT)
MIME-Version: 1.0
From:   Alfredo Deza <adeza@redhat.com>
Date:   Thu, 19 Sep 2019 09:03:22 -0400
Message-ID: <CAC-Np1xa5riFgb_tZG3vFn-dcuKtyV+BSCBZV6uu8+6JRrnrWQ@mail.gmail.com>
Subject: Set/Unset OSD 'Allows Journal'
To:     ceph-devel <ceph-devel@vger.kernel.org>
X-MC-Unique: 1c9OwVgqO8qhdzKec-HsFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

After deploying Ceph with ceph-deploy on Bionic, the latest luminous
(12.2.12) has ceph-disk creating a file for a journal - something that
is very surprising as I have never seen that functionality in
ceph-disk, without specifying any flags that might indicate a file is
needed.

Using the same approach with ceph-ansible, the OSD would be created
with a partition (again, via ceph-disk). Same arguments and all,
similar to:

ceph-disk -v prepare --cluster=3Dceph --filestore --dmcrypt /dev/sdX

After going through all the ceph-disk output, this line got different
results from the ceph-deploy cluster than the ceph-ansible one:

/usr/bin/ceph-osd --check-allows-journal -i 0 --log-file
/var/log/ceph/$cluster-osd-check.log --cluster ceph --setuser ceph
--setgroup ceph

The ceph-deploy cluster returns a 'no' the ceph-ansible one returns a 'yes'=
.

The documentation doesn't seem to explain where or how to set/unset
this. The references to the flag itself are minimal, just mentioning
that the '--allows-journal' flag is to check if a journal is allowed
or not.

How does one tell a cluster that a journal is allowed (or not)?

I am happy to go and expand on the documentation to explain this a bit
even if it is for Luminous only since ceph-volume doesn't check this.

