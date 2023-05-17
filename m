Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB982706D10
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjEQPj6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 11:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjEQPj5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 11:39:57 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50151A25D;
        Wed, 17 May 2023 08:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpnWDtf/isquTMQ8omCxsGJSKpM1VggupY+OU4XYLBWZmv7MCnRzd7i+8m8MeDsPm9ElfoDzh5h/KaXdjFmpAfysTALtupCv4xK/H+QBNQRqhCbLB9XkZHm/H2Pidl8/gKVl/Rf3iXFUq1/RLcDn+id+0e5Tg3NxbAkoHqVxcLkUOBKEnnDWWULfha6N8kToBEbZEvXXUrkSNHum7YDVY1qR+bxrhw2SGAhRk8egGi4OyupOVb+ElDd/i1Ko0sbl4lHmddvkQ1RbTVGcKlnRbbq+Q4uM+VLU63SNRhRKqW+OA3/P8EOu4yXt0RCwT5WTkTwZfedHxD879z8jpQJ/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXibKi/UQ8N/1/7Ah7nbS5EqSWQx95OkO2eWFH0Y3Fo=;
 b=jmHcD2r4cSoVnpiH5vHMGEX/Z22vCyyCIbPVZwoFv+Hf1I08L9ir6AAt8XGrfuIt5JEds3qk+66WLb1gPRu54G2X4VjhpsDXNN+K+YBtygn/VHuOrWBZMxYT67I/Qs4rY4QAKNVr9SurZvpPGr2ALmpKxwMTmilTXUZZQLoM+Vw0oxnF5LyDVXStTs/EgMkXerjLJeAZwWLAmb1kDxPsJNCe9EBPvSvHrDS/4uOq/wROasZI/doadIiNQIZ9VeZRH7cttgD5uaBKtLXrCpVDk6f3z33wwvpGgKYvkaPOx/gBcRIYxS3PPsc/npt5TpcAyUmNRYLeFasNTs8yVb33lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dtu.dk; dmarc=pass action=none header.from=dtu.dk; dkim=pass
 header.d=dtu.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dtu.dk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXibKi/UQ8N/1/7Ah7nbS5EqSWQx95OkO2eWFH0Y3Fo=;
 b=NVP8uSy3q3pUz67XuXOVmF1TWYWg44EwJ/F+K75QdTabyVEQ8Hudc6X7qgzWSK3BcJ5uOwIOnt9Cd3B1bummGvHYqL8dg1nik5krjOJWtKxF3ydpfLHclOCureqzpdN3V6FcAK7AWtJLS9R9hgVNUY+wnT8ngGxZbnne9zxIPEQ=
Received: from DB9P192MB1850.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:39d::9) by
 AM7P192MB0740.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:14f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.35; Wed, 17 May 2023 15:39:50 +0000
Received: from DB9P192MB1850.EURP192.PROD.OUTLOOK.COM
 ([fe80::492a:c36:bd6b:50f3]) by DB9P192MB1850.EURP192.PROD.OUTLOOK.COM
 ([fe80::492a:c36:bd6b:50f3%3]) with mapi id 15.20.6387.034; Wed, 17 May 2023
 15:39:50 +0000
From:   Frank Schilder <frans@dtu.dk>
To:     Gregory Farnum <gfarnum@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
CC:     Xiubo Li <xiubli@redhat.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "vshankar@redhat.com" <vshankar@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
Thread-Topic: [PATCH] ceph: force updating the msg pointer in non-split case
Thread-Index: AQHZiH/ZSxuEBZ3m4EeU4Djz+U027K9eRGcAgAAJZICAAAbwgIAAKbeAgAAH6QCAAAolAIAAAC8AgAACZIA=
Date:   Wed, 17 May 2023 15:39:50 +0000
Message-ID: <DB9P192MB1850391D744321AC8948F013D67E9@DB9P192MB1850.EURP192.PROD.OUTLOOK.COM>
References: <20230517052404.99904-1-xiubli@redhat.com>
 <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
 <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
 <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
 <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
 <CAJ4mKGZ8YRyWYry5F8yAGDhpv3X_LkQHj+f9ONXKsrbWSjDVsQ@mail.gmail.com>
In-Reply-To: <CAJ4mKGZ8YRyWYry5F8yAGDhpv3X_LkQHj+f9ONXKsrbWSjDVsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dtu.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9P192MB1850:EE_|AM7P192MB0740:EE_
x-ms-office365-filtering-correlation-id: d6c1a6f1-1b2a-441b-85f1-08db56ecf3db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5qZ0pes0++CIGbvz5Lnrw5KWa/iwY4Vjdta/vXZgd2FnSNheL6C3DjkK3hYJ5wyV1P24dz817dOQpT7SosAgbgnb8Q9Eo4Cq3Wo05ujmCZx1FpJt0Xn7a8/E/uI71mPy8dWIyCA62f+6/zetyK6UZrdtSzCh6hdMqbg9M0P1zDlwyZPSn59fy7DyQYQVS35Uda6Hq0Dj5kLfWFGqDWjdq/uYwuBgU/hNbGBYcVnIcDlSR4RikNrZ0ywnn17q+1EyyQx2/BCaNrE1b7TVoOyGUgJ60CySjj5v+XOvDiJTLbN1FeTNGUlzUgvE0Ldpiy9pcR4q+y6uALjd19qbhCEGZDfZm0GtZrn08vtSuC42p5YL42WXacDyxeJuatmo9ddZU7drfFk9QVSveqQOE9Gp5BYNtIF5rFUetRyR6C+a+bW4YdAxyPmTgPJA6ObpsYxmEpBKzqQY5x+Cto5XzuLex+ecyXBk5J50LdFvWBVaANAPj9Ouex8p4BqWa774klyWI2TJU8edZy5cq5tCQTMIP2yWPlfbgldU+gqU8s/3upOBZKLzNxm4/Eq8bQXj4TZuktNcRnXqaDaM9kAxWsIYNsm5VBqILPqODLP9WugiQb9mR7W2z40c9F05BNA3E3fj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1850.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199021)(66446008)(66476007)(66556008)(64756008)(76116006)(66946007)(478600001)(9686003)(91956017)(54906003)(786003)(4326008)(110136005)(316002)(7696005)(41300700001)(71200400001)(5660300002)(186003)(26005)(33656002)(8676002)(8936002)(6506007)(52536014)(55016003)(2906002)(41320700001)(83380400001)(38070700005)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?q7hTJDpx2E5uI1NV/9Jq2+hsdlVEv908TKKT1o0kf31Evv+FAFs9AoHzj9?=
 =?iso-8859-1?Q?XP8q19g8YGdef2gJVR2b0BlsvadATzkDsBje8MCmUWvuaalNNDDfvl99kE?=
 =?iso-8859-1?Q?vSWvM5F8Awx2WZBWHqYFxy49X7QjM6QADx1mOaMLwzw3u7blHdDxSLB5Ej?=
 =?iso-8859-1?Q?HkaKGeswUPnrJK0pPECvkr8QuTZTRfodoNsPhpo8ESuXw5kMKdSX542Qj8?=
 =?iso-8859-1?Q?S49obwpGWtiHBLP17fM+v7kD1h4zPtuXfrmd24+4N9hTRIti6odJIrghnw?=
 =?iso-8859-1?Q?EoQ+2tSNLPmmah+2vXiVKWgjS2VEHJ6t/LfaFEAkIJZ9AytzdB2ag8RzcD?=
 =?iso-8859-1?Q?+MbecZCKIiUi8LdgiOadZh4vKrqHnNue/HD7nGIo+3OHGKTNnXY3uNl2jv?=
 =?iso-8859-1?Q?yMlWPUk5Mqh1dZkq01haL1Ctk4Izaa+0p7vjaTNMFnce57rrjO96/xMMGk?=
 =?iso-8859-1?Q?lAD9VdFhoUyvbA1CVdp85KWQkfyotG+KIZwH6f8U+Cx0FDf9um93o5hWVQ?=
 =?iso-8859-1?Q?v3D6V+eAx5nidtay3FILqJCJWStBdYcsyQIurVK2W1F+BIzKrUm1u31XBx?=
 =?iso-8859-1?Q?j0UocS42cHes7JGKR180IoG+Mv9qnWytiXjUl2Sq4jhI5gktrl5aOWLIk8?=
 =?iso-8859-1?Q?AV6FfwxibwKYnyDhRuXeiuFbjclvpedMY+EoCUNL4YDcVFk/jYRG4uJqyn?=
 =?iso-8859-1?Q?M/P2dzn1nF6FDxefHI4CAqG6uRiGG9tUMiqTQsyAiweG0FL4B5VAj+Z1ZK?=
 =?iso-8859-1?Q?wwib7Rh7k3nwJpFcXntqu/H+bdxi6j+EF53pMarVkeWIjOJP1uqXusdKmE?=
 =?iso-8859-1?Q?cWD6755OcRw5hdCVc2sqxAxuscwA3ClJMKh9xflKK5MBktiy/AfRk0FbhM?=
 =?iso-8859-1?Q?Q7BdmeW6xOoUrJUeRC2mmzQfkVYfZrl6rvL1kKYKFGX+LArL/5FfYRuVoP?=
 =?iso-8859-1?Q?mjEwkdDnnEu9q2dBG1lrkHEben0S29dVDM0/fD2C0EhnxOdpxEztQ9UvnC?=
 =?iso-8859-1?Q?uy3/aBoNcwGw48jLx2T58ijuuOFmsEOwl4Vvo2J/nVgp4RFT9gZMAPy788?=
 =?iso-8859-1?Q?C+sFuEpWdNHhvRBXR+qFy5mmNHl7Yq+m7EJ6P18KK3jWr4crEAR7MIV9Pi?=
 =?iso-8859-1?Q?WIdws8nToKWW4aN4tDqygEXuaNajZKTH7TViYAYYzwIbFxqk8ZufHCXH8L?=
 =?iso-8859-1?Q?M7ab8uotjJZ4XJEHftvttOrSL6TE7j6kWLsU9UMRoRQDDg5KMTxrmwBEap?=
 =?iso-8859-1?Q?6g+yyNcK48iqKdQxMX7Q+hCs9lK95mfIIDRl64sLCCtoS/Ogh3VtlRRmWT?=
 =?iso-8859-1?Q?KTDPuG+YESW9ymWeP/jWvgRtRW0Q2RXeixaTKyGgubtWdNwWOlKESYxwWK?=
 =?iso-8859-1?Q?aOfbG8XG78jZd5yQoLGaBVP1+XokyeBtX8ieiDRM+x79m6Uk87FYLZgGJ6?=
 =?iso-8859-1?Q?WPVcHYGxc3gcjE7dc4emVl92fxbhmZZw+4pEujfgnNLTM96TqeuKsOTLEL?=
 =?iso-8859-1?Q?aP+miYp12XoQJU3/X14SKS5M2w+BKyc8xWOer8kohn2qpdD+sh2dvUGIm3?=
 =?iso-8859-1?Q?FdHDxd/4KTQ9vEJS7iVhzOKhbPPwTA6JcpZnKSWDeRz3goepmb4p68zlun?=
 =?iso-8859-1?Q?i9FYmIaoOFQTQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: dtu.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1850.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c1a6f1-1b2a-441b-85f1-08db56ecf3db
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 15:39:50.6372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f251f123-c9ce-448e-9277-34bb285911d9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gq3xNK3ShGTJr9+5qKEkFtB5+iPfD7Cfw1y5/EQSWl2sme8UwM3yOClcWZmpx892
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P192MB0740
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,=0A=
=0A=
joining in here as the one who is hit pretty badly and also not being able =
to upgrade ceph any time soon to a version receiving patches.=0A=
=0A=
For these two reasons alone I strongly favour fixing both sides.=0A=
=0A=
Extra reading, feel free to skip.=0A=
=0A=
Additional reasons for fixing both sides are (1) to have more error toleran=
t code - if one side breaks/regresses the other side still knows what to do=
 and can report back while moving on without a fatal crash and (2) to help =
users of old clusters who are affected without noticing yet. Every now and =
then one should afford to be nice.=0A=
=0A=
I personally think that (1) is generally good practice, explicitly handling=
 seemingly unexpected cases increases overall robustness (its a bit like ra=
iding up code to catch code rot) and will highlight otherwise unnoticed iss=
ues early in testing. It is not the first time our installation was hit by =
an unnecessarily missing catch-all clause that triggered an assert or follo=
w-up crash for no real reason.=0A=
=0A=
The main reason we actually discovered this is that under certain rare circ=
umstances it makes a server with a kclient mount freeze. There is some kind=
 of follow-up condition that is triggered only under heavy load and almost =
certainly only at a time when a snapshot is taken. Hence, it is very well p=
ossible that many if not all users have these invalid snaptrace message on =
their system, but nothing else happens so they don't report anything.=0A=
=0A=
The hallmark in our case is a hanging client caps recall that eventually le=
ads to a spontaneous restart of the affected MDS and then we end up with ei=
ther a frozen server or a stale file handle at the ceph mount point. Others=
 might not encounter these conditions simultaneously on their system as oft=
en as we do.=0A=
=0A=
Apart from that, its not even sure that this is the core issue causing all =
the trouble on our system. Having the kclient fixed would allow us to verif=
y that we don't have yet another problem that should be looked at before co=
nsidering a ceph upgrade - extra reason no. 3.=0A=
=0A=
I hope this was a useful point of view from someone suffering from the cond=
ition.=0A=
=0A=
Best regards and thanks for your efforts addressing this!=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
Frank Schilder=0A=
AIT Ris=F8 Campus=0A=
Bygning 109, rum S14=0A=
