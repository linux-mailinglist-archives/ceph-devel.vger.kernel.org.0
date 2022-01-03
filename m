Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB02483823
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jan 2022 21:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiACU7L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jan 2022 15:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiACU7K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jan 2022 15:59:10 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB42C061761
        for <ceph-devel@vger.kernel.org>; Mon,  3 Jan 2022 12:59:10 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b13so140293750edd.8
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jan 2022 12:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=g8Z10qgIS0EarfPNyU/0T6kl3UEk/EndXdl7judHSI4=;
        b=nFi7UOsgSGmByZou/eZCOm0B5LUIfEIl77IlreUB4NzY7bDdqTCRdqIaUqK4/vMR6I
         Dx5Lz0L8dzE4e70myg1Lxsy1MFiGYtAnX7oclXxhw0Ahyrmf2BlbT8yRmfXyBE9d9GdJ
         30kz2sbf4dga6HpUAT6hBMGCzVXUfWK+HoMiNiWfZz1ad9g6H+C0/jjeNLcZ6HxCFsZ0
         Zfktau3NUvXOzpis69rRp37uCxMcsvV1xalpJFdQaLx+X2treBNntgcIO+sBleLRVDDB
         zYSYmS/M+DYJ/lrpP7xmqgGlI5R3dE/dXGpbDCSoWoRWZaR3HOT4FqKe4HlFuLJWO6FP
         3H8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=g8Z10qgIS0EarfPNyU/0T6kl3UEk/EndXdl7judHSI4=;
        b=Rc1vSc22P0n9uO3z8/emTPxoNC3ivPZ3ktQOrtu6AWCv4fOOFaPNKih+rseF4x2AS6
         tZfQo93B4j/hVIdDNGLMp//WkyuRIEuiR4CBxeaMcFgrjdgCiaz4YBoKoudEfC0fOFO6
         zVWGdlOmJYUswJhf+GR/O2ABuDWDeO/5LKv31pmUOd21972buPFLckeg3Ix0hCvke/MO
         ZECqLIuAcOSEle+0VIxWEnamzafqjX/RXre23B+JvgSPt1IwMDsweMLV8ndLInOSTjyp
         dJF9SRVp8gHTRXXHCbWwnZT29Csztdb4z0dog6PSgSZzWvU1u/2g9n+XVRak+m6DeeKl
         3ZXA==
X-Gm-Message-State: AOAM531mIHHGYOLl3ErvLJMcLO3NGI8ZvUv4aEd/wAsX3F1gWaf0PAxl
        geg+3pFAcl39InsRwkZAbk6MBOwC7j3TBQ==
X-Google-Smtp-Source: ABdhPJzpTIGI/2jmkWECSdcHw+cRh+Rl9MaKgqADeEsqRFdYemUFvhv79oxcA+MpmRE+3Fc63zIhlg==
X-Received: by 2002:aa7:c6c8:: with SMTP id b8mr44960744eds.164.1641243548934;
        Mon, 03 Jan 2022 12:59:08 -0800 (PST)
Received: from [192.168.9.102] ([197.211.59.105])
        by smtp.gmail.com with ESMTPSA id 13sm10907702ejh.225.2022.01.03.12.59.04
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 03 Jan 2022 12:59:08 -0800 (PST)
Message-ID: <61d3639c.1c69fb81.f8991.0c93@mx.google.com>
From:   Margaret Leung KO May-yeee <barjmk79@gmail.com>
X-Google-Original-From: Margaret Leung KO May-yeee
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?Gesch=C3=A4ftsvorschlag?=
To:     Recipients <Margaret@vger.kernel.org>
Date:   Mon, 03 Jan 2022 21:59:00 +0100
Reply-To: la67737777@gmail.com
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Am Mrs. Margaret Leung I have a business proposal for you reach at: la67737=
777@gmail.com

Margaret Leung
Managing Director of Chong Hing Bank
