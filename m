Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821C0D1FF7
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Oct 2019 07:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbfJJFR6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Oct 2019 01:17:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726065AbfJJFR6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 01:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570684677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IIUQsWLLdXyO0HZ5yO9sGqI3kxT6BNrLJms5eiD6EUY=;
        b=cZ/j7m0BJdZtO+vI7SI/wGuP4W2DTxM0dLk+UIDt6IJN++OaE+mj+Hy3MbTlh4hIQrPpIB
        0bMD2HYjnORMPBJ3Imm5PmxCFuKi0BEwv7mspAa0LbE0N0xL8tcrk/sFiNGe4itsnxXNdu
        axNxOOy1d0FVDbm+tiB2ZL1eOk68DNA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-McYF-IoxNwSqYa_xH_Teqg-1; Thu, 10 Oct 2019 01:17:54 -0400
Received: by mail-lf1-f70.google.com with SMTP id y27so1055137lfg.21
        for <ceph-devel@vger.kernel.org>; Wed, 09 Oct 2019 22:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xrTm6Fig/hFlLP9Sp0UitIQO7SCfsxTohGWMxpvxfyU=;
        b=iOAEawcqizEYCpVAJCPteurnmCY4knU0cKgtR6lxxlfa+h2PBKSnktEZzbAl421C2F
         kurrLxXLAY/2nuVUxnNppOyQ9ve+dPGpYqkWHPd0i75EVlpe1c8sPWOUOrV4rRjG9OaS
         s/DJt8qP2h+gvFIKgdM6xJ5fRtq1+MfwmHrpD1B+gaDMcFmMeVOu2cGpG2kY4mv6iesj
         QytBTiFa4xvmmiCW+JqWbX8T5yukJnH8JEdg41FVZ9o4ZsvqFcFotXUZ2uoffzc76qXk
         G2vJJCeCR6guxlypa0hd9Xryue0iKYmLsP04i90GVUjfUt0FUr1GsY0CAUfwxVuZHaID
         +sPw==
X-Gm-Message-State: APjAAAVDm6rPODzCbgQyETafNr5udXTgZ17wOPUuK5RRJwE7hPFd98ul
        MqRGbdsGzf5fXJBJw6+gm1Fde9sLEcJIbR10zbrFdAhewTVJvWtyra+HxSDRwjkrcNBcLL0kO8X
        JKCWEDqrdhPJJEONpqGc/I7bVlG07DMtn9PGYtQ==
X-Received: by 2002:ac2:5c4b:: with SMTP id s11mr4546295lfp.18.1570684672961;
        Wed, 09 Oct 2019 22:17:52 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwc9TCrRbG9u0MwTJtUpIQgO47QER9r+9Um7JYvecngJsEf8vgQSmPBqexh/mOTg7v8DlGsRxhQR+SM6Fw40IY=
X-Received: by 2002:ac2:5c4b:: with SMTP id s11mr4546283lfp.18.1570684672809;
 Wed, 09 Oct 2019 22:17:52 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Thu, 10 Oct 2019 15:17:40 +1000
Message-ID: <CAF-wwdHoUAEqJ7_ep+uDtnqsVDfaNdKQ2XM8T_+a=70mFd=80Q@mail.gmail.com>
Subject: Static Analysis
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
X-MC-Unique: McYF-IoxNwSqYa_xH_Teqg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard=
/

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/


--=20
Cheers,
Brad

