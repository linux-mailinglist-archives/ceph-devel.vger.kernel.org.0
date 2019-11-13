Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3860FAE8C
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 11:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKMKac (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 05:30:32 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:44276 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfKMKac (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 05:30:32 -0500
Received: by mail-oi1-f181.google.com with SMTP id s71so1279992oih.11
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 02:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wkgkBWwrmvUNqJgWfUgMu75e9j+K4hNyMsgkTTekXuY=;
        b=S8/+Q6kggRU4mGvgnpmDE6juhOS0q9zRUlGr4LAA3hC9jbkwqiQf1Y6BgHwxyObHOt
         84EIjRQj1JRCFQQHaNyKi1Yhv1QtpiOQW6iFkPzGZC7C/ap9b3K26ur/3BXZOJCpwGhe
         SLouqdtIMgnr+yGLiUwwBEWIAtSPE23+AbmtMGmyQTdlqp9x25fQUnEVSS8w7d1jBlOA
         jHN9mH4I6V1qAXRDjLp2EPylnx4t2zwExtFp1+vOZojDbDKswYr1XJDaEc79xXtMOAYl
         IBA04TbmMUZJeL6UovkW6+ZbkvmlJhOcEiWeg8cB6yb5rpqRDfocaIMWT2G/svtMx8XN
         ab+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wkgkBWwrmvUNqJgWfUgMu75e9j+K4hNyMsgkTTekXuY=;
        b=rbZryFzivKJp6PZDcJB/afcFPCZ9LOT3ehsImnbCiC6R46t2Rbwcxpa9NKC0/9uov6
         uG5T12Hr+w/OhR+ojUARn6TIB/GXSAlXYXQisCCpE/EcXmON9Iwsr1wZBh5hkux2Ib2q
         6jYmKp7BDZ548frboat7axONjtEV9SGVayIkoieGHEgnrFLzX7CfYb8RjegWEavI+kAD
         y60yRyhGMmZvQt7NmskXEl8mPO+U4cceqE2343RoWY81ZsgH0SkKvM+ajP04fRSmPXQV
         Hzg06KzxKLsdbNf67yd4zA2W/nU70nQKWfqHgc2BpxoDYmAB11ZSR+PYQZcde9m3TIk6
         QNfw==
X-Gm-Message-State: APjAAAVJrRi0gsUm0qXqE47nSmitIdtGi/JwWqTTFAddYI/T2hERBgOH
        RXYwezKbcuuA74tXM1afmv3iIaf9FP+meTrnDyS37w==
X-Google-Smtp-Source: APXvYqwDr26GnCZjxju6cBLUIiI4OBfnGlVkgQxE2g751w9POHdmAHDCz+Y1NsKzFrSqOcUJ/vUO3xLrB7AxPy7WkSc=
X-Received: by 2002:aca:4c4a:: with SMTP id z71mr2611755oia.147.1573641031905;
 Wed, 13 Nov 2019 02:30:31 -0800 (PST)
MIME-Version: 1.0
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Wed, 13 Nov 2019 18:30:19 +0800
Message-ID: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
Subject: Revert a CephFS snapshot?
To:     ceph-users@lists.ceph.com, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Recently, I'm evaluating the snpahsot feature of CephFS from kernel
client and everthing works like a charm.  But, it seems that reverting
a snapshot is not available currently.  Is there some reason or
technical limitation that the feature is not provided?  Any insights
or ideas are appreciated.
