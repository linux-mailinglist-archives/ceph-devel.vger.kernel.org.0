Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FC54C5FC
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 06:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfFTEIk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 00:08:40 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:39760 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfFTEIk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 00:08:40 -0400
Received: by mail-pg1-f169.google.com with SMTP id 196so839303pgc.6
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2019 21:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=a7AadoNY/WrNh71T2NT/dRdDl5KODGXTxd/gv4OyIS8=;
        b=hPyr3kSO2kZmorp7gAKIoEYCILYKaF0pbNqVaFomGzvQlTpt/TLtoktP626K/bft1N
         ejkm+TeTSFKiT54KWeHwrB0euh1SFmEhGFikNsNXrcW6ozHF6uvcOKB49v69wYhH5+pO
         jNMw56C5T6I1LEGyQwwO4+Ei354DKRaJb2uQUsPY4Wbjl/O0OWKt6jYEbTvPNPWCGimV
         /AvCrYymIkaL0EQUJlKIkqW23CTxFjRyZpUOB51DLEaU6fSo+LDuD0v7ELBJZXZTRXBO
         /zJrSPlGC1xz/xkI1TP69V6M8uGf0DIxBIubyFpgDKI+JsdFZsbYJ3S9Iw0yRIqUQdoi
         UK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=a7AadoNY/WrNh71T2NT/dRdDl5KODGXTxd/gv4OyIS8=;
        b=ZI17i5OsEmrnQqJAtp8m+5Og4FEXTjWdbcXzGIYMrYq6GBJOnd5hXinC0C5GMl0Y4e
         01TtfVzfuFp5fsMl8NmZkxp2U54J7zpLMIDeco4yfOeu/aJJUnHlPCh/1u8fCZPJBw2R
         +tPrEhJnr73gyt5t6Vqcy9CHURNin8xa6jrOC97P6U2jEfcettehycKku5vhOhiIclDU
         5uEZrJQ574D2hq0vFpom2vr/GOBMZNxoLHzCy6/GtySkUP5UuSIo5/leuBt6MNkDzKQ9
         4NGX8rFOGlOjQTBeZF2D8Uknrqnl17ULu8zaEKSw0wAl5Kylv/r3Hb+UixFRJb393e8X
         jFeQ==
X-Gm-Message-State: APjAAAWkaUEKWR5aUlM3AnGz43UiRZ0HUwAhqr/GGYbGZICau6Cllkqk
        Jjl7S0gBFQC+mY6iY4LJ1e4JymDY
X-Google-Smtp-Source: APXvYqymhnubAwfkBuAoB2nlk2nuxvOoJ6y1El1XZ/XI8rK6F73BDduLhSQxwektx3WELiflA1/vQw==
X-Received: by 2002:a65:41c7:: with SMTP id b7mr10955085pgq.165.1561003719360;
        Wed, 19 Jun 2019 21:08:39 -0700 (PDT)
Received: from [127.0.0.1] (220-132-77-164.HINET-IP.hinet.net. [220.132.77.164])
        by smtp.gmail.com with ESMTPSA id b8sm25591443pff.20.2019.06.19.21.08.37
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 21:08:38 -0700 (PDT)
From:   =?gb2312?B?zNW2rLas?= <tdd21151186@gmail.com>
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: backport PR https://github.com/ceph/ceph/pull/26564
Message-Id: <221D4B4C-BF10-4E9C-AB29-BDD1F1563941@gmail.com>
Date:   Thu, 20 Jun 2019 12:08:35 +0800
To:     Ceph Development <ceph-devel@vger.kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Cephers,

Since this PR is important for lifecycle to be able to work.
I=A1=AFm wondering if there is anyone working on backporting PR =
https://github.com/ceph/ceph/pull/26564 to Luminous and Mimic.
I saw it=A1=AFs pending from ticket =
https://tracker.ceph.com/issues/38882 and =
https://tracker.ceph.com/issues/38884
I can be able to help to work on this if no one is working on it ?

Thanks,
Dongdong=
