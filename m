Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A257369F6
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 04:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfFFCYM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 22:24:12 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:43451 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfFFCYM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 22:24:12 -0400
Received: by mail-lj1-f178.google.com with SMTP id 16so470396ljv.10
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 19:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XK2PvMZwyLWtpaf2+8ptRINBpKiIpfHoEVXoc+mFOdM=;
        b=DcGgkauFZF5IOEOBdaO4QEVfhKmm/MhHiBWlmJqEvZz+pulakm8n0yw9vsg2DgBm1v
         upsIGg4mNwPX6Wgk0XzyM42tQIdVvJETO1pBlj0UMl6/BIyK65K5Z6WBbYluvX/92IiC
         0r2K9Cu9jPD/2zp47ryRzWYDvGF6wySTzGaj59/o2YsPx3b5w/M/+fYs4KRL36oSq5Nx
         qDlSLILMHCpXgeItlzKATpQ7WjJJIFBNnpoePqG71upKE4mHDd8z6g5rOfizshlKFLwS
         lPAx3AybsOXcQwm5OoBAylNulL9jciPMT+KeFjlphPYmWWt58yt2EuecbRv9w5Yh9CRT
         qS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XK2PvMZwyLWtpaf2+8ptRINBpKiIpfHoEVXoc+mFOdM=;
        b=Ex9bd6DWf19qFfkCnqxHNx4lHhppAxHP4fOjxHXQdg4jlFohh3g0cySeLEL4KVlia7
         pb8oy5RMOpxo/yskWQKIZOUCzEICgFGF9s4UTNMaSuS91Y0I0wgjnIpJxYD6YOaTy/vy
         R88AQYkPF63pvMgRRV4q9PFqv2mKhtozOYO9oSGDY3KD0wRNZArZICeGDWFeKZ0WacHm
         FNnOI5MVRWBXOqun4n9YrfDH8hAt8ZGfqFfI2lmW9zrC2PKiQRubNZL2b/BctqIBtOgX
         pNcE+doTfKNJuVIuUxTeOEr2EdCWyS+YQmQ+rIlViv2hvXqk4JCa8bTabV4xnkZmTI71
         EBCw==
X-Gm-Message-State: APjAAAUMJs73OmlITzww+kpMg79ljsUQ7Gmho9tImFKfQUZoMKy+YH23
        wRIStxe+T4vPhjiOgjMB5Xe8u/p78ayGBqZ5YUNIFl+/
X-Google-Smtp-Source: APXvYqwrl7z835ca38U1PU5JtTnrgOx871gyTdkJPScwwHVTBj22jU262uQl7DxyyjwoPLHCW7wzh2g9okGxE/r1m+Y=
X-Received: by 2002:a2e:154c:: with SMTP id 12mr10400956ljv.149.1559787850235;
 Wed, 05 Jun 2019 19:24:10 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1905301812380.29593@piezo.novalocal> <alpine.DEB.2.11.1906051630420.13706@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906051630420.13706@piezo.novalocal>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Thu, 6 Jun 2019 10:23:55 +0800
Message-ID: <CAJACTufv89tC=BOGJLn=ufjdh9q25NFcETg-nfodk_Rxh=KLmg@mail.gmail.com>
Subject: Re: CDM next Wednesday: multi-site rbd and cephfs; rados progress events
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> BTW for those using Chrome, for some reason using the redhat.bluejean.com
> URL variant works better for me (doesn't prompt me to install the app):
>
> https://redhat.bluejeans.com/908675367
>
> sage

Hi, everyone.

Sorry, I missed the CDM last night, I was too tired and had to work at day time.
Could anyone share the recording, please? Thanks:-)
