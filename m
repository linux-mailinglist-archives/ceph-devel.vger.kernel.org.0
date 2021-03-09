Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC78E3330F1
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Mar 2021 22:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhCIVbE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Mar 2021 16:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbhCIVau (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Mar 2021 16:30:50 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865E9C06174A
        for <ceph-devel@vger.kernel.org>; Tue,  9 Mar 2021 13:30:50 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id h18so13573272ils.2
        for <ceph-devel@vger.kernel.org>; Tue, 09 Mar 2021 13:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJT+iH+BrjU76VrFOCccJDxskodsmDiuXhk0totbwO4=;
        b=CNXQe7TqYsYTLYoEZzl4BTELxptw6qFrrNpmsS5rBOXCVuDvOBSOJZvzWH+IGJX2RB
         Df0gtF9dqv/g7RzAWsWFL7wdjYbUKdKzGUkoi7dfRuL/UW0fIiC0pUCApT69vSRPPCCh
         XPzdARgFMzVL4ETHShe+aS+LWe0kTeY3JHvaOHJtncMU/3oebirS+lrjF50SnQaXCB48
         ZR3bt8wMutdTroX2EhW+GiS3FQW4LqapF+7QwK7mySj7ayJJaxuECyej4KafN1SU/Lwf
         1pG8hDR+tjQnyev0nKkmQ7gpAag4Z5Y+sAs0DheOZHohIGcp5Kl46kUohQd+4xJF8fHe
         oxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJT+iH+BrjU76VrFOCccJDxskodsmDiuXhk0totbwO4=;
        b=WCSmKz0He6b2Ug3iTy26dyb9hlt3pPqL8CydFivtF3XlHcFboHzxeGxfJff4XxZ6tn
         r0Rf2rtS/n2cxm70C8+JbO2sslm43EzJ8VZdlOzSaA5y/ZD3G/I57Ow7UfxqFwGm1DXJ
         BF7AtrA3RsQabS3mmR+cfvu9eLeLWmvBl/QfA+VcsK0xKznMnySr7NU/FmlcJWFBvgMo
         sXZWDf6mTQxOE6hdgWJ+MU9ZqrB3LCSeKaBjn2Cf17l2PjwS/q9cj/+fNg9SsU7Sdggh
         qeErPacS88ZtJwvqndLNH9Jmbn2uZ7oV0scNqA4XPybOwZECU4e3oCbCFxa2IB/Fgwy/
         R3jA==
X-Gm-Message-State: AOAM530ff/wHlX7Kl4fIpx1P5DDSeGyaNDxsFQlTxyUgxvZB18c37roX
        4g/1lUFY0PtmQ8av0kbl3/xFo9Tbics11wQbFp8=
X-Google-Smtp-Source: ABdhPJwMdMMIpaZjjUv3WRTUrg0HtIwxwVPXt033UoWjRlKbEByBzlkDmlE4adRtDW/wWUcryHsSiLdJNNMKBvdLMXY=
X-Received: by 2002:a05:6e02:12b4:: with SMTP id f20mr156954ilr.220.1615325449900;
 Tue, 09 Mar 2021 13:30:49 -0800 (PST)
MIME-Version: 1.0
References: <ac3703b3b382cc6e947904238e3dc4c671eb7847.camel@kernel.org>
In-Reply-To: <ac3703b3b382cc6e947904238e3dc4c671eb7847.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 9 Mar 2021 22:30:42 +0100
Message-ID: <CAOi1vP9g+wFpw6ws5ap9T4nbPxLK0J-KegeoH4HZXQhC=UL2-g@mail.gmail.com>
Subject: Re: ceph-client/testing branch rebased
To:     David Howells <dhowells@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 9, 2021 at 8:36 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Just a heads-up that I've rebased the ceph-client/testing branch onto
> David Howells' fscache-netfs-lib branch (which is itself based on top of
> v5.12-rc2).

Hi David,

Could you please create a named branch that doesn't include AFS bits
(e.g. netfs-next)?  It is going to be needed once we get closer to
a merge window and netfs helper library is finalized.  I won't be able
to pull a seemingly random SHA (of the commit preceding the first AFS
commit) into ceph-client/master.

Thanks,

                Ilya
