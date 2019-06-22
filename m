Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F484F8F4
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Jun 2019 01:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFVXdl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 22 Jun 2019 19:33:41 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:39485 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVXdl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 22 Jun 2019 19:33:41 -0400
Received: by mail-ed1-f54.google.com with SMTP id m10so15661725edv.6
        for <ceph-devel@vger.kernel.org>; Sat, 22 Jun 2019 16:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4/edo9J6VfA81vSKs5kW/sw9mfIRKxWumRjByrsZxcw=;
        b=Wq6W+h363bslOmocvub/1GOkCyAj9UWlYmWLoVs3ErHVaqyRtD7/lsUWlMloJeojQE
         HucdZ68USDMllPeHtqfQWe8Z2i2xSdL12ObmkH1bkNIoZNvrOEQ5TVgvFwSBcS+YBWe0
         TU3qJWSY4UGdzq+YWLolGAXcjav/Ox1B7BoQXCWopVTqXPpl4qV4elPd25Z+wq86ef02
         0np8reIutgsrkkrvxKjPh71ScqfbJtRdpMIvrPHBjrr4bg3PSDPOlq3aMdRYDh9uW3Pj
         SQJ0xsju+5oeNqOx3jJErFPxOcJDOMdJM9UR2zN1Wkzys+pNN1pcvtyLhDPwZ7WnAqlB
         M/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4/edo9J6VfA81vSKs5kW/sw9mfIRKxWumRjByrsZxcw=;
        b=WvcqHRBsHRQ38y1vCci6NersEh4XlDb+h14i+YJzzzKDMNM3Bcv+P2UBzcqGF+TD5K
         oPpsYkhTfh3W2wEy8cMPXKRfwBikOh7Zf6ZPhRQRxgiEOGmyFql/SGfqRvZkvdf0WjGb
         pDHfNF1rnxVSblZGRxS0EYOJJnfPX+S9A27g/pNFWksG6BESpjq5Tb2szBP3AjJdXL0o
         FJekn7fFZPauoNilkhf7+BEr/rjO8304WwNOOYK3zXNFZ5BrGf2EtaosKjg79MKPJsqJ
         K79dNu2Eww2wil1ZL+4NcF2seOyuPZH4LiotSHuNZnJVGHXavhrDuhAxEmmAFFuU3S2Z
         acQA==
X-Gm-Message-State: APjAAAVys6q2A+y8tDqCvg9sdgKQuRtZpF1T/E70W3FtRPR4s4AsoyVL
        38n3KnO+a/lchhw2X4VEZEXJuwqrEvMSImATR6cIJejFrOk=
X-Google-Smtp-Source: APXvYqyXO5v9RMgJVv321BNSluwE76DajFN16yIbGJqM5zCRHLMkQinFf8q5ulWtZRa2PH52RYtyoSPlhiNBfcF8RUI=
X-Received: by 2002:a50:9003:: with SMTP id b3mr108490834eda.40.1561246418936;
 Sat, 22 Jun 2019 16:33:38 -0700 (PDT)
MIME-Version: 1.0
From:   lin zhou <hnuzhoulin2@gmail.com>
Date:   Sun, 23 Jun 2019 07:33:27 +0800
Message-ID: <CAKO+7k304JfiN3Drgy9BDsKxXzCip7180NckQoeBo2BJxb2xgQ@mail.gmail.com>
Subject: near 300 pg per osd make cluster very very unstable?
To:     ceph-devel@vger.kernel.org
Cc:     ceph-users <ceph-users@lists.ceph.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

recently our ceph cluster very unstable, even replace a failed disk
may trigger a chain reaction,  cause large quantities of osd been
wrongly marked down.
I am not sure if it is because we have near 300 pgs in each sas osds
and small bigger than 300  pgs for ssd osd.

from logs, it all starts from osd_op_tp timed out, then osd no reply,
then large wrongly mark down.

1. 45 machines, each machine has 16 sas and 8 ssd, all file journal in
the osd data dir.
2. use rbd in this cluster
3. 300+ compute node to hold vm
4. osd node current has a hundred thousand threads and fifty thousand
established network connection.
5. dell R730xd, and dell say no hardware error log

so someone else faces the same unstable problem or using 300+ pgs?
