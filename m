Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0671F2607B8
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Sep 2020 02:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgIHAgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Sep 2020 20:36:04 -0400
Received: from mgw.moi.go.th ([103.28.100.190]:65304 "EHLO mta1-mgw.moi.go.th"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgIHAgC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 7 Sep 2020 20:36:02 -0400
X-Greylist: delayed 683 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2020 20:36:01 EDT
X-Mailborder-Info: host=mgw, gmt_time=1599524674, scan_time=4.56s
X-Mailborder-Spam-Score: 7.4
X-Mailborder-Spam-Report: BAYES_00, URIBL_BLOCKED, SPF_HELO_NONE, SUBJ_ALL_CAPS, MISSING_HEADERS, FREEMAIL_REPLYTO_END_DIGIT, MB_FROM_NOT_REPLYTO, DKIM_SIGNED, DKIM_VALID_AU, DKIM_VALID, PYZOR_CHECK, REPLYTO_WITHOUT_TO_CC, FSL_BULK_SIG, MB_DMARC_PASS, FREEMAIL_FORGED_REPLYTO, 
Received: from mail.moi.go.th (mail.moi.go.th [103.28.100.3])
        by mta1-mgw.moi.go.th (Postfix) with ESMTPS id 15E9A61624;
        Tue,  8 Sep 2020 07:19:57 +0700 (+07)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta1-mgw.moi.go.th 15E9A61624
Authentication-Results: mgw; dmarc=pass (p=quarantine dis=none) header.from=moi.go.th
Authentication-Results: mgw; spf=pass smtp.mailfrom=zonel1-3@moi.go.th
DKIM-Filter: OpenDKIM Filter v2.11.0 mta1-mgw.moi.go.th 15E9A61624
Authentication-Results: mta1-mgw.moi.go.th;
        dkim=pass (2048-bit key; unprotected) header.d=moi.go.th header.i=@moi.go.th header.b="EaAe9R8N";
        dkim-atps=neutral
Received: from localhost (localhost [127.0.0.1])
        by mail.moi.go.th (Postfix) with ESMTP id ECE5910173EE2;
        Tue,  8 Sep 2020 07:19:56 +0700 (+07)
Received: from mail.moi.go.th ([127.0.0.1])
        by localhost (mail.moi.go.th [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id x39k8CblQ6VA; Tue,  8 Sep 2020 07:19:56 +0700 (+07)
Received: from localhost (localhost [127.0.0.1])
        by mail.moi.go.th (Postfix) with ESMTP id 539DF10173EFA;
        Tue,  8 Sep 2020 07:19:56 +0700 (+07)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.moi.go.th 539DF10173EFA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=moi.go.th;
        s=B1BC2C72-96A5-11E7-924D-813AC853CE7B; t=1599524396;
        bh=5RQctR0XgwivC0hX4xwKP9O6YfxG6zOppPjIJX9fFjc=;
        h=Date:From:Message-ID:MIME-Version;
        b=EaAe9R8Nu8Avyz/EwJtllz9zLQH/8FDI6FMvWzhkkDSPD0HqrFfKSaHL24yhuAO/0
         LbDxiCrsRBzncf0ykF/VtYN2ZbxYUm09dPBqt8MFjbl8bW9hOArqZ8cVxz7S4CKrci
         N+hIVmGpEAg3qLx05YI7YnMZ4blXNYwradGJbGL4wqRps5Jpj2GLCMT68LCKlXyzMx
         K2vuWSDS5GlaLe74TIJU/WxqeF2cqZY9GBiH1xz8CemfVKzJZmwqC5KA/CNRf7zozq
         DJzxHPIMPX1jQuj7LdPSlOPqS4eWjvw/I/WeNEJ5itYooyuhDERkjpSb1pWDkpJvJ/
         sudX8Ot47ZxxA==
X-Virus-Scanned: amavisd-new at mail.moi.go.th
Received: from mail.moi.go.th ([127.0.0.1])
        by localhost (mail.moi.go.th [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AnVSdMgaEr7q; Tue,  8 Sep 2020 07:19:56 +0700 (+07)
Received: from mail.moi.go.th (mail.moi.go.th [103.28.100.3])
        by mail.moi.go.th (Postfix) with ESMTP id 690E310173EE2;
        Tue,  8 Sep 2020 07:19:54 +0700 (+07)
Date:   Tue, 8 Sep 2020 07:19:54 +0700 (ICT)
From:   DIRECTION OEA CANADA <zonel1-3@moi.go.th>
Reply-To: directionoeacanada1@gmail.com
Message-ID: <1048742334.2049.1599524394389.JavaMail.zimbra@moi.go.th>
Subject: RECRUTEMENT INTERNATIONALE DE L'OEA CANADA!
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [103.28.100.3]
X-Mailer: Zimbra 8.7.11_GA_1854 (zclient/8.7.11_GA_1854)
Thread-Index: xGvl/xUvQttlq1lUR5jBQbBTq6ej6Q==
Thread-Topic: RECRUTEMENT INTERNATIONALE DE L'OEA CANADA!
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

PROGRAMME DE RECRUTEMENT INTERNATIONALE OEA CANADA
Vous souhaitez travailler pour OEA au Canada
Nous avons besoin de plus de travailleurs pour venir travailler au Canada!
L=E2=80=99expertise, le professionnalisme, l=E2=80=99aptitude =C3=A0 travai=
ller dans un environnement intergouvernemental et multiculturel constituent=
 les principales valeurs communes aux diff=C3=A9rentes professions de l'OEA=
. Ainsi pour la promotion de l'emploi et l'insertion professionnelle des je=
unes dipl=C3=B4m=C3=A9s pour atteindre les objectifs de l'ONU. l'OEA -CANAD=
A lance un programme d'avis de recrutement de personnels de toutes cat=C3=
=A9gories confondus de part le monde entier sans distinction de race, de na=
tionalit=C3=A9 et ni de sexe. Ce projet est destin=C3=A9 a toute personne m=
orale pr=C3=AAt =C3=A0 voyager et =C3=A0 s=E2=80=99installer au Canada afin=
 de lutter contre le vieillissement de la population canadienne qui pourrai=
t doubler dans les 10% prochaines ann=C3=A9es. Nous recherchons avant tout =
des personnes capables de s=E2=80=99adapter =C3=A0 notre environnement de t=
ravail.

Condition normal a remplir
=E2=80=A2 Avoir entre 20 et 59 ans au plus
=E2=80=A2 =C3=8Atre de bonne moralit=C3=A9
=E2=80=A2 =C3=8Atre disponible pour voyager
=E2=80=A2 =C3=8Atre titulaire du BACCALAUR=C3=89AT ou autre dipl=C3=B4me pr=
ofessionnel
=E2=80=A2 Avoir acquis d'exp=C3=A9rience professionnelle serait un atout
=E2=80=A2 Savoir parler le Fran=C3=A7ais ou l=E2=80=99Anglais

Si vous =C3=AAtes int=C3=A9ress=C3=A9s, veuillez envoyer votre CV accompagn=
=C3=A9 de votre lettre de motivation adress=C3=A9e au DRH de l'OEA =C3=A0 :=
 directionoeacanada1@gmail.com
Liste des pi=C3=A8ces =C3=A0 fournir
- Un Curriculum Vitae (CV)
- Une Lettre de motivation
- Une Photo d'identit=C3=A9
- les copies des dipl=C3=B4mes
- les attestations de travail ou les certificats des services rendus.

#IMPORTANT : Seul(e)s les candidat(e)s pr=C3=A9s=C3=A9lectionn=C3=A9s seron=
t contact=C3=A9s pour suite du recrutement.
Postulez d=C3=A8s maintenant et connectez-vous =C3=A0 votre carri=C3=A8re.

Bureau de Recrutement l'OEA CANADA
Le Secr=C3=A9tariat Administratif
E-mail: directionoeacanada1@gmail.com

#Offre valable jusqu'au 30 Septembre 2020
#URGENT [partager ce message avec vos amis,votre famille ainsi que vos cont=
acts]

