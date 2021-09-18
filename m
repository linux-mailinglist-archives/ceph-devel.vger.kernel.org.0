Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E09410730
	for <lists+ceph-devel@lfdr.de>; Sat, 18 Sep 2021 16:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbhIRO6J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 18 Sep 2021 10:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239121AbhIRO6I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 18 Sep 2021 10:58:08 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60565C061574
        for <ceph-devel@vger.kernel.org>; Sat, 18 Sep 2021 07:56:44 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id 42so915831uar.5
        for <ceph-devel@vger.kernel.org>; Sat, 18 Sep 2021 07:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=HOpYuHKwwaBgnxKJyXw+EAEyJXE8To38BHfYsZNybag=;
        b=KPglIVYfyK228zpSaygL/9VzWiywZcqzGVSUkZTzewShHEB9GmMpOPyOwfIWlctw5f
         AA5xrjfZUHbvEBcu4T1TiUiuklyXbR2A0gZy0FCRQ4rr+07SBESlVrg9V3bwjmca/JyM
         WwfnsGSwl9qNFnLh8IgcEC4ugBiVZ8NOn+p0zJp1e0VXTEHHPlTDACvGb/yGQ2hLwELJ
         KWVAlT3T6cnUP9J/squ3Gk/D523EyseXjn66aHUH21ArQ8Yl2NwgKzq7gRvpR62IrRiK
         6tCHeybWGwclWUj8S+esbvRB0aMG8UFzig0Nbb4VCNpqo4fTbsgXtt6jBDO82kJBtrKq
         5YgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=HOpYuHKwwaBgnxKJyXw+EAEyJXE8To38BHfYsZNybag=;
        b=E190hFDmOHGjVOlaXqyJgVYVuZIjuFMdy3VlthY/Yu0xGnI+zuVuuICQBI0owBz6Ju
         eizWsECOduyQZ0X9lXc/fTlUA9qWV+dJ8quoMJids75UMg69FiXtoayteX+qHBvfbNNB
         mCPQZKgg/R6AZ6BTu8x+XGwc1Mh8pjEEsKSMUStu8bUVfez2yCf5mNM/FXtHePa0M9Bl
         T9KwlGA/UrxGQmmvhAQlV0xFGlOQD6QQzypA/QhktpnNvb1x4ClsYtaeJhhZA8Axgrv5
         Pp3CsTFMaWhKbIkqOjUqWZYTVJlCJK/GiHPBw9BsrS5OUsiKoI42lfG7bGmRAVjKwlAV
         hSDw==
X-Gm-Message-State: AOAM532mMOT2iDqXBQan6HViikTMw9Uk2BuIAjBaNO6va+1HkLLC5GAG
        8+Y3Wvs5zt4M35FwCf2AdK8F+BLnyOLsBs3zwrI=
X-Google-Smtp-Source: ABdhPJx1AyzftkcqbC78TMi9eiaK/87zD7mswVcSMAnnw+x1CI6Pk/y92QM/Hksw4x33emmwb3VCpk1B1B8u7oasiRo=
X-Received: by 2002:ab0:6dc7:: with SMTP id r7mr8125509uaf.14.1631977003170;
 Sat, 18 Sep 2021 07:56:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:f8cf:0:0:0:0:0 with HTTP; Sat, 18 Sep 2021 07:56:42
 -0700 (PDT)
Reply-To: mohammed.conde2020@gmail.com
From:   =?UTF-8?Q?Mohammed_Cond=C3=A9?= <nasha.tagro201@gmail.com>
Date:   Sat, 18 Sep 2021 14:56:42 +0000
Message-ID: <CAE9pyzDP1FPQAJnj7GqeCnCse02AftLpfOYWYx-34vYM=9Tyww@mail.gmail.com>
Subject: Could you help me in this transaction?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Hello,
I am sorry that my letter may violate your privacy. I am Mohammed
Cond=C3=A9, the son to the former president of the Republic of Guinea who
as toppled in a military coup on the 5th septembre 2021. I solicit
your assistance for a fund transfer to your country for urgent
investment on important projects., If you are interested to help me i
will accord you twenty percent of the total fund. Please contact me
here: (mohammed.conde2020@gmail.com)
Regards
Mohammed
