Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4253103937
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 12:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfKTL4c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 06:56:32 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:36201 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbfKTL4c (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Nov 2019 06:56:32 -0500
Received: by mail-oi1-f171.google.com with SMTP id j7so22243801oib.3
        for <ceph-devel@vger.kernel.org>; Wed, 20 Nov 2019 03:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hCh3JhsBbJkmosgEJlWGe1ATNEqp3mBCGlsmXAqoFl8=;
        b=mIGqsKxA03ACTtdWL4zx/2o9bbD9XmVh6Qx1/bXMZHShnMQy5jVTwRnnb/pSL3F3kv
         oSyDsSz+U4/1oeuDAF1+OgITeNBIM8M2nVT69mEnI9sWYuY47TmqF3Cnof+IbqXPKpNI
         fK4DXpCQCvJbRJKgayuEiE9lpc+1dCpE9j0GgBI6PmmdYfcsN6rDX6x/Kf83EgjVUm0M
         i/bS6vNsRLwfGsu/Gi5fbg88nQyi5CBGE++1TG5X2/7C2AUG0t2v+G4SLSEG13p8xZJf
         Dedd4n1kmUqjiH84ELYpUwFyCDNOpNa5baOZdDFLm6M28F4Q9A9poOwIWbssQFFiET6a
         CDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hCh3JhsBbJkmosgEJlWGe1ATNEqp3mBCGlsmXAqoFl8=;
        b=CN66bPoIgqHM0gYA6pLt4kQ+V2F9yTF3hoHUKg1Kj3jNqpCncwSxiTlOva0MdWZ1iR
         eZ9ujr1haf5/NiGEsptQw/b+UPZ5+kVXqcn+u2Yw+Svs0qCJPgVYOvOeDGVBYnBtBRsx
         3DC+7NlvtmQDGnXhNNqqY00dBjLAHi5azvqvzSU9hcdNcr5Q77RnJ5wpLovMFlZR6nht
         FGkPC6XUDbxuQuGRNfIgYwoYnY2Soy8s1zrPy7E4yR4BZyghByjnJwapDgE2U7LdkNp8
         MapGwuXyfuMkP9mOn4JfryIuEQIvaMp3NcCp+FbulvXnbCKD5589sf5XRZhN4swfIbNS
         U35g==
X-Gm-Message-State: APjAAAW6MHiwVmkHQRC768LdjFS1vZlX4UxPU8+b9D6AiMdUADR+Tl13
        slZ4/JEYOJtGm7/SxBQfcEj3QZ6Fnn0hwwVV8IAsvg==
X-Google-Smtp-Source: APXvYqwK09CjoVeXI/keKtg67GvCtmb1ZzsHUzx+ZrSdTGRaNQ9ilkpcctW8TOxlV/YLQ+4f9FeNYlykcU5VhZ+f//M=
X-Received: by 2002:aca:5e04:: with SMTP id s4mr2453265oib.159.1574250991783;
 Wed, 20 Nov 2019 03:56:31 -0800 (PST)
MIME-Version: 1.0
From:   Xinying Song <songxinying.ftd@gmail.com>
Date:   Wed, 20 Nov 2019 19:56:20 +0800
Message-ID: <CAMWWNq--jjHMGub+SM1krwfULOaaGYLdpgykSbnizmh-Otkmyg@mail.gmail.com>
Subject: RGW: what is RGWCopyObj used for?
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, cephers:
Can anybody give some explains about RGWCopyObj? It seems what
RGWCopyObj can do can also be done by RGWPutObj. And RGWPutObj does
more, it can handle copy-source-range header and uploadId. Why do we
still retain RGWCopyObj=EF=BC=9F

Thanks=EF=BC=81
